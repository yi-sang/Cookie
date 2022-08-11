//
//  HomeVC.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/04/30.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxKeyboard
import AppTrackingTransparency
import GoogleMobileAds

final class HomeVC: BaseVC, View, HomeCoordinator {
    private weak var coordinator: HomeCoordinator?
    
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
        self.reactor?.action.onNext(.viewDidLoad)
        self.navigationItem.titleView = homeView.searchBar
        self.coordinator = self
        self.homeView.bannerView.rootViewController = self
        self.loadAd()
    }
    
    static func instance() -> UINavigationController {
        let viewController = HomeVC.init(nibName: nil, bundle: nil)
        //            .then {
        //            $0.tabBarItem = UITabBarItem (
        //                title: "홈화면",
        //                image: nil,
        //                tag: TabBarTag.home.rawValue
        //            )
        //        }
        return UINavigationController(rootViewController: viewController)
    }
    
    override func bindEvent() {
        homeView.searchBar.rx.textDidBeginEditing
            .asDriver()
            .drive (onNext: { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                    self.homeView.searchBar.searchTextField.backgroundColor = UIColor(rgb: 0xCBCBD0)
                    self.homeView.removeOriginSubviews()
                    if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                        self.homeView.setupAdditionalSubviews(status: 3)
                    } else {
                        self.homeView.setupAdditionalSubviews(status: -1)
                    }
                } completion: { Bool in
                    self.homeView.searchBar.searchTextField.backgroundColor = UIColor(rgb: 0xECECEE)
                    self.homeView.searchBar.showsCancelButton = true
                    self.homeView.searchBar.searchTextField.tintColor = .darkGray
                }
            }).disposed(by: eventDisposeBag)
        
        RxKeyboard.instance.visibleHeight
            .filter { $0.isNormal }
            .asDriver()
            .drive (onNext: { [weak self] in
                guard let self = self else { return }
                let height = $0 - self.homeView.safeAreaInsets.bottom
                if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                    self.homeView.updateAdditionalSubviews(status: 3, offset: height)
                } else {
                    self.homeView.updateAdditionalSubviews(status: -1, offset: height)
                }
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) {
                    self.homeView.layoutIfNeeded()
                }
            })
            .disposed(by: eventDisposeBag)

        
        homeView.searchBar.rx.cancelButtonClicked
            .asDriver()
            .drive (onNext: { [weak self] in
                guard let self = self else { return }
                self.homeView.searchBar.searchTextField.resignFirstResponder()
                self.homeView.removeAdditionalSubviews()
                self.homeView.searchBar.text = ""
                self.homeView.searchBar.showsCancelButton = false
                self.homeView.setup()
                self.homeView.bindConstraints()
                if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                    self.homeView.loadAdView()
                } else {
                    self.homeView.loadNoAdView()
                }
                self.loadAd()
            }).disposed(by: eventDisposeBag)
    }
    
    func bind(reactor: HomeReactor) {
        // Action        
        homeView.searchBar.rx.text
            .orEmpty
            .filter { $0 != "" }
            .distinctUntilChanged()
            .compactMap { keyword in Reactor.Action.searchTextDidChanged(query: keyword) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        homeView.movieHorizontalCollectionView.rx.contentOffset
            .filter { [weak self] offset in
                guard let self = self else { return false }
                let collectionView = self.homeView.movieHorizontalCollectionView
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
        
        homeView.searchBar.rx.cancelButtonClicked
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: eventDisposeBag)
        
        homeView.movieHorizontalCollectionView.rx.itemSelected
            .map { Reactor.Action.horizontalItemSelected(index: $0.row) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        homeView.movieVerticalCollectionView.rx.itemSelected
            .map { Reactor.Action.verticalItemSelected(index: $0.row) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state
            .map { $0.movieSection }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .nowPlaying)
            .drive(onNext: { [weak self] section in
                guard let self = self else { return }
                self.homeView.nowPlayingButton.isSelected.toggle()
                self.homeView.upcomingButton.isSelected.toggle()
                self.homeView.movieHorizontalCollectionView.contentOffset = CGPoint(x: 0, y: 0)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.movieList }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(
                self.homeView.movieHorizontalCollectionView.rx.items
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
            .map { $0.searchMovieList }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(
                self.homeView.movieVerticalCollectionView.rx.items
            ) { collectionView, row, movie in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchMovieCell.registerId,
                    for: indexPath
                ) as? SearchMovieCell else { return BaseCollectionViewCell()
                }
                cell.bind(movie: movie)
                return cell
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.movieInfo }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: RevisionedData<Movie>(revision: 0, data: Movie()))
            .drive(onNext: { [weak self] movieInfo in
                guard let self = self else { return }
                self.coordinator?.showDetail(movie: movieInfo.data!)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadAd() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { [self] status in
            if status == .authorized {
                self.homeView.loadAdView()
            } else {
                self.homeView.loadNoAdView()
            }
        })
    }
}
