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
        $0.numberOfLines = 5
    }
    
    var foldButton = UIButton().then {
        $0.setTitle("...더보기", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitle("접기", for: .selected)
        $0.setTitleColor(.gray, for: .selected)
        $0.titleLabel?.font = .jalnan(size: 14)
    }
    
    var voteLabel = UILabel().then {
        $0.text = "투표하기"
        $0.textColor = .black
        $0.font = .jalnan(size: 14)
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    var grayView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 20
    }
    
    var stackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.alignment = .leading
        $0.axis = .horizontal
    }
    
    var dishButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.image = R.image.dish()?.resizeImage(size: CGSize(width: 75, height: 75))
        $0.configuration?.title = "쿠키 없음"
        $0.configuration?.attributedTitle?.font =  .jalnan(size: 14)
        $0.configuration?.baseForegroundColor = .black
        $0.configuration?.imagePlacement = .top
    }
    
    var oneCookieButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.image = R.image.oneCookie()?.resizeImage(size: CGSize(width: 75, height: 75))
        $0.configuration?.title = "쿠키 하나"
        $0.configuration?.attributedTitle?.font =  .jalnan(size: 14)
        $0.configuration?.baseForegroundColor = .black
        $0.configuration?.imagePlacement = .top
    }
    
    var twoCookieButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.image = R.image.twoCookie()?.resizeImage(size: CGSize(width: 75, height: 75))
        $0.configuration?.title = "쿠키 둘"
        $0.configuration?.attributedTitle?.font =  .jalnan(size: 14)
        $0.configuration?.baseForegroundColor = .black
        $0.configuration?.imagePlacement = .top
    }
    
        
    override func setup() {
        self.addSubViews(
            playerView,
            titleLabel,
            releaseDateLabel,
            overViewLabel,
            foldButton,
            grayView
        )
        grayView.addSubViews(
            voteLabel,
            stackView
        )
        self.stackView.addArrangedSubview(dishButton)
        self.stackView.addArrangedSubview(oneCookieButton)
        self.stackView.addArrangedSubview(twoCookieButton)

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
        }
        
        foldButton.snp.makeConstraints {
            $0.top.equalTo(overViewLabel.snp.bottom)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
        
        grayView.snp.makeConstraints {
            $0.top.equalTo(voteLabel).offset(-5)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.bottom.equalTo(stackView).offset(5)
        }
        
        voteLabel.snp.makeConstraints {
            $0.top.equalTo(foldButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(voteLabel.snp.bottom)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(100)
        }
    }
    
    func increaseConstraint() {
        overViewLabel.numberOfLines = 0
    }
    
    func decreaseConstraint() {
        overViewLabel.numberOfLines = 5
    }
    
    
}
