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
        case buttonClicked(section: MovieSection)
        case searchTextDidChanged(query: String)
        case verticalItemSelected(index: Int?)
        case horizontalItemSelected(index: Int?)
    }
    
    enum Mutation {
        case fetchMovieList([Movie], section: MovieSection)
        case fetchSearchingMovieList([Movie])
        case appendMovieList([Movie], nextPage: Int)
        case setLoadingNextPage(Bool)
        case fetchDetail(movieInfo: Movie?)
    }
    
    struct State {
        var movieList: [Movie] = []
        var searchMovieList: [Movie] = []
        var nextPage: Int = 1
        var isLoadingNextPage: Bool = false
        var movieSection: MovieSection = .nowPlaying
        var retry: Bool = true
        var movieInfo = RevisionedData<Movie>(revision: 0, data: nil)
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
            return movieService.getMovies(page: 1, section: .nowPlaying)
                .map{ $0.movieList }
                .map{ Mutation.fetchMovieList($0, section: .nowPlaying) }
        case let .buttonClicked(section):
            let sectionToggled: Bool =  self.currentState.movieSection == section ? false : true
            if sectionToggled {
                return movieService.getMovies(page: 1, section: section)
                    .map{ $0.movieList }
                    .map{ Mutation.fetchMovieList($0, section: section) }
            } else {
                return Observable.empty()
            }
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            let page = self.currentState.nextPage
            let movieSection = self.currentState.movieSection
            if self.currentState.retry == true {
                return Observable.concat([
                    Observable.just(Mutation.setLoadingNextPage(true)),
                    movieService.getMovies(page: page, section: movieSection)
                        .map{ $0.movieList }
                        .map{ Mutation.appendMovieList($0, nextPage: page)},
                    Observable.just(Mutation.setLoadingNextPage(false))
                ])
            } else {
                return Observable.empty()
            }
        case let .searchTextDidChanged(query):
            return movieService.getSearchMovies(page: 1, query: query)
                .map{ $0.movieList }
                .map{ Mutation.fetchSearchingMovieList($0) }
        case let .verticalItemSelected(index):
            return Observable.just(Mutation.fetchDetail(movieInfo: currentState.searchMovieList[index!]))
        case let .horizontalItemSelected(index):
            return Observable.just(Mutation.fetchDetail(movieInfo: currentState.movieList[index!]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .fetchMovieList(movieList, section):
            newState.movieList = movieList
            newState.movieSection = section
            newState.nextPage = 2
            newState.searchMovieList = []
            newState.retry = true
        case let .appendMovieList(movieList, nextPage):
            let isEmpty = movieList.isEmpty ? false : true
            newState.retry = isEmpty
            newState.movieList.append(contentsOf: movieList)
            newState.nextPage = nextPage + 1
        case let .setLoadingNextPage(isLoadingNextPage):
            newState.isLoadingNextPage = isLoadingNextPage
        case let .fetchSearchingMovieList(movieList):
            newState.searchMovieList = movieList
        case let .fetchDetail(movieInfo):
            newState.movieInfo = state.movieInfo.update(movieInfo)
        }
        return newState
    }
}
