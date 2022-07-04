//
//  BaseVC.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/04/28.
//

import UIKit
import RxSwift

class BaseVC: UIViewController {
    var disposeBag = DisposeBag()
    let eventDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        self.bindViewModelInput()
        self.bindViewModelOutput()
        bindEvent()
    }
    
    func bindViewModel() { }
    
    func bindViewModelInput() { }
    
    func bindViewModelOutput() { }
    
    func bindEvent() { }
    
//    func showRootLoading(isShow: Bool) {
//        if let tabBarVC = self.navigationController?.parent as? TabBarVC {
//            tabBarVC.showLoading(isShow: isShow)
//        }
//    }
}

