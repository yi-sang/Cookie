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
        case loadupcomingNextPage
        case loadNowPlayingNextPage
    }
    
    enum Mutation {
        case fetchMovieList([Movie], nextPage: Int, section: SectionType)
        case appendMovieList([Movie], nextPage: Int, section: SectionType)
        case setLoadingNextPage(Bool, section: SectionType)
    }
    
    struct State {
        var upcomingMovieList: [Movie] = []
        var nowPlayingMovieList: [Movie] = []
        var upcomingNextPage: Int?
        var nowPlayingNextPage: Int?
        var isLoadingupcomingNextPage: Bool = false
        var isLoadingNowPlayingNextPage: Bool = false
    }
    
    let initialState: State
    enum SectionType: Int {
        case upcoming
        case nowPlaying
    }
    
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
            return Observable.merge([movieService.getupcomingMovieInfo(page: 1)
                .map{ $0.results }
                .map{ Mutation.fetchMovieList($0, nextPage: 1, section: .upcoming) },
                                     movieService.getNowPlayingMovieInfo(page: 1)
                .map{ $0.results }
                .map{ Mutation.fetchMovieList($0, nextPage: 1, section: .nowPlaying) }
            ])
                    
        case .loadupcomingNextPage:
            guard !self.currentState.isLoadingupcomingNextPage else { return Observable.empty() }
            guard let page = self.currentState.upcomingNextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true, section: .upcoming)),
                movieService.getupcomingMovieInfo(page: page)
                    .map{ $0.results }
                    .map{ Mutation.appendMovieList($0, nextPage: page, section: .upcoming) },
                Observable.just(Mutation.setLoadingNextPage(false, section: .upcoming))
            ])
        case .loadNowPlayingNextPage:
            guard !self.currentState.isLoadingNowPlayingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nowPlayingNextPage else { return Observable.empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true, section: .nowPlaying)),
                movieService.getNowPlayingMovieInfo(page: page)
                    .map{ $0.results }
                    .map{ Mutation.appendMovieList($0, nextPage: page, section: .nowPlaying) },
                Observable.just(Mutation.setLoadingNextPage(false, section: .nowPlaying))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchMovieList(movieList, page, sectionType):
            switch sectionType {
            case .upcoming:
                newState.upcomingMovieList = movieList
                newState.upcomingNextPage = page + 1
            case .nowPlaying:
                newState.nowPlayingMovieList = movieList
                newState.nowPlayingNextPage = page + 1
            }
        case let .appendMovieList(movieList, nextPage, sectionType):
            switch sectionType {
            case .upcoming:
                newState.upcomingMovieList.append(contentsOf: movieList)
                newState.upcomingNextPage = nextPage + 1
            case .nowPlaying:
                newState.nowPlayingMovieList.append(contentsOf: movieList)
                newState.nowPlayingNextPage = nextPage + 1
            }
            
        case let .setLoadingNextPage(isLoadingNextPage, sectionType):
            switch sectionType {
            case .upcoming:
                newState.isLoadingupcomingNextPage = isLoadingNextPage
            case .nowPlaying:
                newState.isLoadingNowPlayingNextPage = isLoadingNextPage
            }
        }
        return newState
    }
}
