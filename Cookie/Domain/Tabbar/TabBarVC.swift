//
//  TabBarVC.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import UIKit
import RxSwift

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let disposeBag = DisposeBag()
    private let loadingView = LoadingView()
    
    static func instance() -> TabBarVC {
        return TabBarVC(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBarController()
        self.delegate = self

    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.feedbackGenerator.selectionChanged()
        switch item.tag {
        case TabBarTag.home.rawValue:
            break
        case TabBarTag.my.rawValue:
            break
        default:
            break
        }
    }
    
    private func setupTabBarController() {
        self.setViewControllers([
            HomeVC.instance(),
            MyPageVC.instance(),
        ], animated: true)
        
        self.tabBar.tintColor = R.color.red()
        self.tabBar.layer.borderWidth = 0
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.barTintColor = .white
    }
}

