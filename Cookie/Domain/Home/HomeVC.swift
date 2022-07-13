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
    private var homeView = HomeView()
    
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
        // Action
        homeView.movieCollectionView.rx.contentOffset
            .filter { [weak self] offset in
            guard let self = self else { return false }
            let collectionView = self.homeView.movieCollectionView
            guard collectionView.frame.width > 0 else { return false }
            return offset.x + collectionView.frame.size.width >= collectionView.contentSize.width - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        homeView.nowPlayingButton.rx.tap
            .map { Reactor.Action.buttonClicked(section: .nowPlaying) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        homeView.upcomingButton.rx.tap
            .map { Reactor.Action.buttonClicked(section: .upcoming) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    
        reactor.state
            .map { $0.movieSection }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .nowPlaying)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.homeView.nowPlayingButton.isSelected.toggle()
                self.homeView.upcomingButton.isSelected.toggle()
                self.homeView.movieCollectionView.contentOffset = CGPoint(x: 0, y: 0)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.movieList }
            .asDriver(onErrorJustReturn: [])
            .drive(
                self.homeView.movieCollectionView.rx.items
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
    }
}
