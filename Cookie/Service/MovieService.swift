//
//  MovieService.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import Alamofire
import RxSwift

protocol MovieProtocol {
    func getupcomingMovieInfo(page: Int) -> Observable<MovieResponse>
    func getNowPlayingMovieInfo(page: Int) -> Observable<MovieResponse>
}

struct MovieService: MovieProtocol {
    func getupcomingMovieInfo(page: Int) -> Observable<MovieResponse> {
        return Observable.create { observer -> Disposable in
            let urlString = HTTPUtils.url + "3/movie/upcoming"
            let headers = HTTPUtils.jsonHeader()
            let parameters: Parameters = [
                "api_key" : Storage.shared.apiKey,
                "language" : Storage.shared.language,
                "page" : page,
                "region" : Storage.shared.region
            ]
            HTTPUtils.defaultSession.request(
                urlString,
                method: .get,
                parameters: parameters,
                headers: headers
            ).responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let response):
                    observer.onNext(response)
                    observer.onCompleted()

                case .failure:
                    let error = CommonError(description: "데이터를 파싱할 수 없습니다.")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getNowPlayingMovieInfo(page: Int) -> Observable<MovieResponse> {
        return Observable.create { observer -> Disposable in
            let urlString = HTTPUtils.url + "3/movie/now_playing"
            let headers = HTTPUtils.jsonHeader()
            let parameters: Parameters = [
                "api_key" : Storage.shared.apiKey,
                "language" : Storage.shared.language,
                "page" : page,
                "region" : Storage.shared.region
            ]
            HTTPUtils.defaultSession.request(
                urlString,
                method: .get,
                parameters: parameters,
                headers: headers
            ).responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let response):
                    observer.onNext(response)
                    observer.onCompleted()

                case .failure:
                    let error = CommonError(description: "데이터를 파싱할 수 없습니다.")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
