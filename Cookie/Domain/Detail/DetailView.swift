//
//  DetailView.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/18.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class DetailView: BaseView {
    var playerView = UIPlay
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    var overViewLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    override func setup() {
        
        self.addSubViews(
            imageView,
            titleLabel,
            overViewLabel
        )
        self.backgroundColor = .systemGray
    }
    
    override func bindConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(UIScreen.main.bounds.width)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.trailing.equalTo(imageView)
        }
        overViewLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalTo(imageView)
            $0.height.equalTo(200)
        }
    }
}
