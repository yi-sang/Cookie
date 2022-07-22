//
//  DetailReacor.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/18.
//

import RxSwift
import RxCocoa
import ReactorKit

final class DetailReacor: BaseReactor, Reactor {
    private let movieService: MovieProtocol

    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
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
        
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}
