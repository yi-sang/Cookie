//
//  HomeCoordinator.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/18.
//

protocol HomeCoordinator: Coordinator, AnyObject {
    func showDetail(movie: Movie)
}

extension HomeCoordinator where Self: BaseVC {
    func showDetail(movie: Movie) {
        let viewController = DetailVC.instance(movie: movie)
        
        self.presenter.present(viewController, animated: true, completion: nil)
    }
}
