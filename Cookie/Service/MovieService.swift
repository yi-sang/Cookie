//
//  MovieService.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import Alamofire
import RxSwift
import Firebase

protocol MovieProtocol {
    func getMovies(page: Int, section: MovieSection) -> Observable<MovieResponse>
    func getSearchMovies(page: Int, query: String) -> Observable<MovieResponse>
    func getKoreanVideo(id: Int) -> Observable<VideoResponse>
    func getVideo(id: Int) -> Observable<VideoResponse>
    func getCookieData(id: Int) -> Observable<TotalCookie>
    func postNoCookieData(id: Int) -> Observable<TotalCookie>
    func postOneCookieData(id: Int) -> Observable<TotalCookie>
    func postTwoCookieData(id: Int) -> Observable<TotalCookie>
}

struct MovieService: MovieProtocol {
    let uuid = Storage.shared.uuid

    func getMovies(page: Int, section: MovieSection) -> Observable<MovieResponse> {
        return Observable.create { observer -> Disposable in
            let urlString = HTTPUtils.url + "3/movie/\(section.rawValue)"
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
    
    func getSearchMovies(page: Int, query: String) -> Observable<MovieResponse> {
        return Observable.create { observer -> Disposable in
            let urlString = HTTPUtils.url + "3/search/movie/"
            let headers = HTTPUtils.jsonHeader()
            let parameters: Parameters = [
                "api_key" : Storage.shared.apiKey,
                "language" : Storage.shared.language,
                "query" : query,
                "page" : page,
                "include_adult" : true,
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
    
    func getKoreanVideo(id: Int) -> Observable<VideoResponse> {
        return Observable.create { observer -> Disposable in
            let urlString = HTTPUtils.url + "3/movie/\(id)/videos"
            let headers = HTTPUtils.jsonHeader()
            let parameters: Parameters = [
                "api_key" : Storage.shared.apiKey,
                "language" : Storage.shared.language
            ]
            HTTPUtils.defaultSession.request(
                urlString,
                method: .get,
                parameters: parameters,
                headers: headers
            ).responseDecodable(of: VideoResponse.self) { response in
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
    
    func getVideo(id: Int) -> Observable<VideoResponse> {
        return Observable.create { observer -> Disposable in
            let urlString = HTTPUtils.url + "3/movie/\(id)/videos"
            let headers = HTTPUtils.jsonHeader()
            let parameters: Parameters = [
                "api_key" : Storage.shared.apiKey,
            ]
            HTTPUtils.defaultSession.request(
                urlString,
                method: .get,
                parameters: parameters,
                headers: headers
            ).responseDecodable(of: VideoResponse.self) { response in
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
//    
    func getCookieData(id: Int) -> Observable<TotalCookie> {
        return Observable.create { observer -> Disposable in
            let db = Database.database().reference(withPath: "movie")
            db.observeSingleEvent(of: .value, with: { snapshot in
                let movieID = String(id)
                if snapshot.hasChild(movieID) {
                    let value = snapshot.childSnapshot(forPath: movieID).value
                    guard let data = try? JSONSerialization.data(withJSONObject: value as Any) else { return }
                    let decoder = Firebase.JSONDecoder()
                    guard let totalCookie = try? decoder.decode(TotalCookie.self, from: data) else { return }
                    observer.onNext(totalCookie)
                    observer.onCompleted()
                } else {
                    let totalCookie = TotalCookie()
                    db.child(movieID).setValue(totalCookie.toDictionary())
                    observer.onNext(totalCookie)
                    observer.onCompleted()
                }
            }) { error in
                print(error)
            }
            return Disposables.create()
        }
    }
    
    func postNoCookieData(id: Int) -> Observable<TotalCookie> {
        return Observable.create { observer -> Disposable in
            let db = Database.database().reference(withPath: "movie")
            db.observeSingleEvent(of: .value, with: { snapshot in
                let movieID = String(id)
                if snapshot.hasChild(movieID) {
                    let value = snapshot.childSnapshot(forPath: movieID).value
                    guard let data = try? JSONSerialization.data(withJSONObject: value as Any) else { return }
                    let decoder = Firebase.JSONDecoder()
                    guard var totalCookie = try? decoder.decode(TotalCookie.self, from: data) else { return }
                    
                    if let index = totalCookie.personal.firstIndex(of: Cookie(uuid: uuid, cookieType: 0)) {
                        let movie = db.child(movieID)
                        movie.child("personal").child("\(index)").removeValue()
                        totalCookie.personal.remove(at: index)
                        totalCookie.noCookie -= 1
                        movie.setValue(totalCookie.toDictionary())
                    } else {
                        let cookie = Cookie(uuid: uuid, cookieType: 0)
                        totalCookie.personal.append(cookie)
                        totalCookie.noCookie += 1
                        db.child(movieID).setValue(totalCookie.toDictionary())
                        
                    }
                    observer.onNext(totalCookie)
                    observer.onCompleted()
                }
            }) { error in
                print(error)
            }
            return Disposables.create()
        }
    }
    
    func postOneCookieData(id: Int) -> Observable<TotalCookie> {
        return Observable.create { observer -> Disposable in
            let db = Database.database().reference(withPath: "movie")
            db.observeSingleEvent(of: .value, with: { snapshot in
                let movieID = String(id)
                if snapshot.hasChild(movieID) {
                    let value = snapshot.childSnapshot(forPath: movieID).value
                    guard let data = try? JSONSerialization.data(withJSONObject: value as Any) else { return }
                    let decoder = Firebase.JSONDecoder()
                    guard var totalCookie = try? decoder.decode(TotalCookie.self, from: data) else { return }
                    
                    if let index = totalCookie.personal.firstIndex(of: Cookie(uuid: uuid, cookieType: 1)) {
                        let movie = db.child(movieID)
                        movie.child("personal").child("\(index)").removeValue()
                        totalCookie.personal.remove(at: index)
                        totalCookie.oneCookie -= 1
                        movie.setValue(totalCookie.toDictionary())
                    } else {
                        let cookie = Cookie(uuid: uuid, cookieType: 1)
                        totalCookie.personal.append(cookie)
                        totalCookie.oneCookie += 1
                        db.child(movieID).setValue(totalCookie.toDictionary())
                        
                    }
                    observer.onNext(totalCookie)
                    observer.onCompleted()
                }
            }) { error in
                print(error)
            }
            return Disposables.create()
        }
    }
    
    func postTwoCookieData(id: Int) -> Observable<TotalCookie> {
        return Observable.create { observer -> Disposable in
            let db = Database.database().reference(withPath: "movie")
            db.observeSingleEvent(of: .value, with: { snapshot in
                let movieID = String(id)
                if snapshot.hasChild(movieID) {
                    let value = snapshot.childSnapshot(forPath: movieID).value
                    guard let data = try? JSONSerialization.data(withJSONObject: value as Any) else { return }
                    let decoder = Firebase.JSONDecoder()
                    guard var totalCookie = try? decoder.decode(TotalCookie.self, from: data) else { return }
                    
                    if let index = totalCookie.personal.firstIndex(of: Cookie(uuid: uuid, cookieType: 2)) {
                        let movie = db.child(movieID)
                        movie.child("personal").child("\(index)").removeValue()
                        totalCookie.personal.remove(at: index)
                        totalCookie.twoCookie -= 1
                        movie.setValue(totalCookie.toDictionary())
                    } else {
                        let cookie = Cookie(uuid: uuid, cookieType: 2)
                        totalCookie.personal.append(cookie)
                        totalCookie.twoCookie += 1
                        db.child(movieID).setValue(totalCookie.toDictionary())
                        
                    }
                    observer.onNext(totalCookie)
                    observer.onCompleted()
                }
            }) { error in
                print(error)
            }
            return Disposables.create()
        }
    }
}
