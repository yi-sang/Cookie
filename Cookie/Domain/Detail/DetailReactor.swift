//
//  DetailReacor.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/18.
//

import RxSwift
import RxCocoa
import ReactorKit

final class DetailReactor: BaseReactor, Reactor {
    private let movieService: MovieProtocol

    enum Action {
        case viewDidLoad(id: Int)
        case retry(id: Int)
        case noCookieClicked(id: Int)
        case oneCookieClicked(id: Int)
        case twoCookieClicked(id: Int)
    }
    
    enum Mutation {
        case fetchKoreanVideo(key: String)
        case fetchVideo(key: String)
        case fetchCookie(totalCookie: TotalCookie)
    }
    
    struct State {
        var key : String = ""
        var newKey : String = ""
        var totalCookie: TotalCookie?
    }
    
    let initialState: State
    init(
        movieService: MovieProtocol
    ) {
        self.movieService = movieService
        self.initialState = State()
        
        super.init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .viewDidLoad(id):
            return Observable.merge(
                movieService.getCookieData(id: id)
                    .map { Mutation.fetchCookie(totalCookie: $0) },
                movieService.getKoreanVideo(id: id)
                    .map { $0.results.first?.key ?? "" }
                    .map { Mutation.fetchKoreanVideo(key: $0)}
            )
        case let .retry(id):
            return movieService.getVideo(id: id)
                .map { $0.results.first?.key ?? "" }
                .map { Mutation.fetchVideo(key: $0) }
            
        case let .noCookieClicked(id):
            return movieService.postNoCookieData(id: id)
                .map { Mutation.fetchCookie(totalCookie: $0) }
        case let .oneCookieClicked(id):
            return movieService.postOneCookieData(id: id)
                .map { Mutation.fetchCookie(totalCookie: $0) }
        case let .twoCookieClicked(id):
            return movieService.postTwoCookieData(id: id)
                .map { Mutation.fetchCookie(totalCookie: $0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchKoreanVideo(key):
            newState.key = key
        case let .fetchVideo(key):
            newState.newKey = key
        case let .fetchCookie(totalCookie):
            newState.totalCookie = totalCookie
        }
        return newState
    }
}
