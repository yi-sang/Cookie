//
//  HomeReactor.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/04/30.
//

import RxSwift
import RxCocoa
import ReactorKit

final class HomeReactor: BaseReactor, Reactor {
    
    private let movieService: MovieProtocol
    
    enum Action {
        case viewDidLoad
        case loadNextPage
    }
    
    enum Mutation {
        case fetchMovieList([Movie], nextPage: Int)
        case appendMovieList([Movie], nextPage: Int)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var movieList: [Movie] = []
        var nextPage: Int?
        var isLoadingNextPage: Bool = false
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
        case .viewDidLoad:
            return movieService.getMovieInfo(page: 1)
                .map{ $0.results }
                .map{ Mutation.fetchMovieList($0, nextPage: 1) }
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                movieService.getMovieInfo(page: page)
                    .map{ $0.results }
                    .map{ Mutation.appendMovieList($0, nextPage: page) },
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchMovieList(movieList, page):
            newState.movieList = movieList
            newState.nextPage = page + 1
        case let .appendMovieList(movieList, nextPage: nextPage):
            newState.movieList.append(contentsOf: movieList)
            newState.nextPage = nextPage + 1
        case let .setLoadingNextPage(isLoadingNextPage):
            newState.isLoadingNextPage = isLoadingNextPage
        }
        return newState
    }
}
