//
//  BaseViewModel.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/04/28.
//

import RxSwift
import RxCocoa

class BaseViewModel {
  
  let disposeBag = DisposeBag()
  let showLoading = PublishRelay<Bool>()
  
  init() {
    self.bind()
  }
  
  func bind() {
    
  }
}
