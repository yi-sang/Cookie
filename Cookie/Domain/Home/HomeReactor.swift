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
    }
    
    enum Mutation {
        case movieList([Movie])
    }
    
    struct State {
        var movieList: [Movie] = []
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
            return movieService.getMovieInfo()
                .map{ $0.result }
                .map{ Mutation.movieList($0) }
            }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .movieList(movieList):
            newState.movieList = movieList
        }
        return newState
    }
}
