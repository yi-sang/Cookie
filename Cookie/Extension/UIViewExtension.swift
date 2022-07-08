//
//  UIViewExtension.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/08.
//

import UIKit

extension UIView {
  
  func addSubViews(_ views: UIView...) {
    for view in views {
      self.addSubview(view)
    }
  }
}
