//
//  HomeVC.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/04/30.
//

import UIKit
import ReactorKit
import RxDataSources
import RxSwift

final class HomeVC: BaseVC, View {
    private let homeReactor = HomeReactor(
        movieService: MovieService()
    )
    private let homeView = HomeView()
    
    override func loadView() {
      self.view = self.homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = self.homeReactor
        homeReactor.action.onNext(.viewDidLoad)
    }
    
    static func instance() -> UINavigationController {
        let viewController = HomeVC.init(nibName: nil, bundle: nil).then {
            $0.tabBarItem = UITabBarItem (
                title: "홈화면",
                image: nil,
                tag: TabBarTag.home.rawValue
            )
        }
        return UINavigationController(rootViewController: viewController)
    }

    func bind(reactor: HomeReactor) {
        reactor.state
            .map { $0.upcomingMovieList }
            .asDriver(onErrorJustReturn: [])
            .drive(
                self.homeView.upcomingMovieCollectionView.rx.items
            ) { collectionView, row, movie in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieCell.registerId,
                    for: indexPath
                ) as? MovieCell else { return BaseCollectionViewCell()
                }
                cell.bind(movie: movie)
                return cell
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.nowPlayingMovieList }
            .asDriver(onErrorJustReturn: [])
            .drive(
                self.homeView.nowPlayingMovieCollectionView.rx.items
            ) { collectionView, row, movie in
                let indexPath = IndexPath(row: row, section: 0)

                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieCell.registerId,
                    for: indexPath
                ) as? MovieCell else { return BaseCollectionViewCell()
                }
                cell.bind(movie: movie)
                return cell
            }
            .disposed(by: self.disposeBag)
        
        homeView.upcomingMovieCollectionView.rx.contentOffset
            .filter { [weak self] offset in
            guard let self = self else { return false }
            let collectionView = self.homeView.upcomingMovieCollectionView
            guard collectionView.frame.width > 0 else { return false }
            return offset.x + collectionView.frame.size.width >= collectionView.contentSize.width - 100
            }
            .map { offset in
                Reactor.Action.loadupcomingNextPage
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        homeView.nowPlayingMovieCollectionView.rx.contentOffset
            .filter { [weak self] offset in
            guard let self = self else { return false }
            let collectionView = self.homeView.nowPlayingMovieCollectionView
            guard collectionView.frame.width > 0 else { return false }
            return offset.x + collectionView.frame.size.width >= collectionView.contentSize.width - 100
            }
            .map { offset in
                Reactor.Action.loadNowPlayingNextPage
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}
