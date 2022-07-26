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
    
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .jalnan(size: 20)
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    var releaseDateLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .gray
        $0.font = .jalnan(size: 14)
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    var overViewLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.textAlignment = .center
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
    }
    override func setup() {
        
        self.addSubViews(
            playerView,
            titleLabel,
            releaseDateLabel,
            overViewLabel
        )
        self.backgroundColor = .white
    }
    
    override func bindConstraints() {
        playerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.playerView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(20)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(20)
        }
        
        overViewLabel.snp.makeConstraints {
            $0.top.equalTo(releaseDateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.lessThanOrEqualTo(200)
        }
    }
}
