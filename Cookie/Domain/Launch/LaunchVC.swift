//
//  LaunchVC.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import UIKit
import RxSwift

class LaunchVC: BaseVC {
    private let launchView = LaunchView()
    private let viewModel = LaunchViewModel()
    
    static func instance() -> LaunchVC {
      return LaunchVC.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
      self.view = self.launchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.launchView.startAnimation { [weak self] in
            self?.viewModel.input.viewDidLoad.onNext(())
        }
    }
    
    override func bindViewModel() {
      self.viewModel.output.goToMain
        .asDriver(onErrorJustReturn: ())
        .drive(onNext: self.goToMain)
        .disposed(by: disposeBag)
    }
    
    private func goToMain() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.goToMain()
        }
    }
}
