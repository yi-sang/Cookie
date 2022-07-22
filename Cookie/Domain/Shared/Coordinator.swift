//
//  Coordinator.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/18.
//

import UIKit

protocol Coordinator {
    var presenter: BaseVC { get }
    
    func popup()
    func dismiss()
}

extension Coordinator where Self: BaseVC {
    
    var presenter: BaseVC {
        return self
    }
    
    func popup() {
        self.presenter.navigationController?.popViewController(animated: true)
    }
    
    func dismiss() {
        self.presenter.dismiss(animated: true, completion: nil)
    }
}
