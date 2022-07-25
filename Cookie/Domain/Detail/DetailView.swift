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
import youtube_ios_player_helper

class DetailView: BaseView {
    var playerView = YTPlayerView()
    
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .jalnan(size: 14)
        $0.sizeToFit()
    }
    
    var overViewLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
    }
    override func setup() {
        
        self.addSubViews(
            playerView,
            imageView,
            titleLabel,
            overViewLabel
        )
        self.backgroundColor = .systemGray
    }
    
    override func bindConstraints() {
        playerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.6)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(self.playerView.snp.bottom)
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(self.safeAreaLayoutGuide).dividedBy(3)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.5)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView).offset(10)
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(self.safeAreaLayoutGuide)
        }
        overViewLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(self.safeAreaLayoutGuide)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(imageView)
        }
    }
}
