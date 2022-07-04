//
//  HomeVC.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/04/30.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

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
        homeReactor.action.onNext(.viewDidLoad)
        
        reactor.state
            .map { $0.movieList }
            .map { $0.first?.movieName }
            .asDriver(onErrorJustReturn: "")
            .drive(homeView.textLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.movieList }
            .map { $0.description }
            .asDriver(onErrorJustReturn: "")
            .drive(homeView.textLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
