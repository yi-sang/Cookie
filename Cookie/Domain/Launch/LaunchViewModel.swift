//
//  LaunchViewModel.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import RxSwift
import RxCocoa

final class LaunchViewModel: BaseViewModel {
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
    }
    
    struct Output {
        let goToSignIn = PublishRelay<Void>()
        let goToMain = PublishRelay<Void>()
    }
    
    let input = Input()
    let output = Output()
    
    override init() {
        super.init()
        
        input.viewDidLoad
            .bind(onNext: { [weak self] in
                self?.output.goToMain.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    func goToSignIn() {
        window?.rootViewController = TabBarVC.instance()
        window?.makeKeyAndVisible()
    }
}
