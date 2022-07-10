//
//  BaseCollectionViewCell.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
    bindConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
    bindConstraints()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
      
    self.disposeBag = DisposeBag()
  }
  
  func setup() { }
  
  func bindConstraints() { }
}
