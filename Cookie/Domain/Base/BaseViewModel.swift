//
//  BaseViewModel.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
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
