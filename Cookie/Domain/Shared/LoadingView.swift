//
//  LoadingView.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import UIKit
import Then
import SnapKit

class LoadingView: UIView {
    let loadingImageView = UIImageView().then {
        $0.image = R.image.dish()
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.bindConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(loadingImageView)
    }
    
    private func bindConstraints() {
        loadingImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
}

