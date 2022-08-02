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
    
    var noCookieButton = UIButton().then {
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
        $0.configuration?.title = "쿠키 두개"
        $0.configuration?.attributedTitle?.font =  .jalnan(size: 14)
        $0.configuration?.baseForegroundColor = .black
        $0.configuration?.imagePlacement = .top
    }
    
    var imageButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.title = ""
        $0.configuration?.attributedTitle?.font =  .jalnan(size: 20)
        $0.configuration?.baseForegroundColor = .black
        $0.configuration?.imagePlacement = .top
        $0.isUserInteractionEnabled = false
    }
    
    var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    var contentView = UIView()

    var pickerView = UIPickerView().then {
        $0.isUserInteractionEnabled = false
    }
    
    var experienceLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .jalnan(size: 14)
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    var slider = Slider().then {
        $0.minimumValue = 0
        $0.maximumValue = 10
    }
    
    var faithList = ["might...?", "may..?", "should..!", "must!", "will!!!"]
    
    override func setup() {
        self.addSubViews(
            playerView,
            scrollView
        )
        scrollView.addSubview(contentView)
        contentView.addSubViews(
            titleLabel,
            releaseDateLabel,
            overViewLabel,
            foldButton,
            grayView,
            imageButton,
            pickerView,
            experienceLabel,
            slider
        )
        
        grayView.addSubViews(
            voteLabel,
            stackView
        )
        
        self.stackView.addArrangedSubview(noCookieButton)
        self.stackView.addArrangedSubview(oneCookieButton)
        self.stackView.addArrangedSubview(twoCookieButton)
        self.backgroundColor = .white
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    override func bindConstraints() {
        playerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.5)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.playerView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView)
            $0.leading.trailing.equalTo(contentView).inset(10)
            $0.height.equalTo(20)
        }
        
        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(10)
            $0.height.equalTo(20)
        }
        
        overViewLabel.snp.makeConstraints {
            $0.top.equalTo(releaseDateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(10)
        }
        
        foldButton.snp.makeConstraints {
            $0.top.equalTo(overViewLabel.snp.bottom)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        grayView.snp.makeConstraints {
            $0.top.equalTo(voteLabel).offset(-5)
            $0.leading.trailing.equalTo(contentView).inset(10)
            $0.bottom.equalTo(stackView).offset(5)
        }
        
        voteLabel.snp.makeConstraints {
            $0.top.equalTo(foldButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(10)
            $0.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(voteLabel.snp.bottom)
            $0.leading.trailing.equalTo(contentView).inset(10)
            $0.height.equalTo(100)
        }
        
        experienceLabel.snp.makeConstraints {
            $0.top.equalTo(grayView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        slider.snp.makeConstraints {
            $0.top.equalTo(experienceLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        pickerView.snp.makeConstraints {
            $0.centerY.equalTo(imageButton)
            $0.height.equalTo(imageButton)
            $0.trailing.equalTo(self.snp.centerX)
            $0.leading.equalTo(self)
        }
        
        imageButton.snp.makeConstraints {
            $0.top.equalTo(slider.snp.bottom)
            $0.leading.equalTo(contentView.snp.centerX)
            $0.trailing.equalTo(self)
            $0.bottom.equalTo(contentView)
        }
    }
    
    func increaseConstraint() {
        overViewLabel.numberOfLines = 0
    }
    
    func decreaseConstraint() {
        overViewLabel.numberOfLines = 5
    }
}

extension DetailView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.faithList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return faithList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = .jalnan(size: 20)
        pickerLabel.text = faithList[row]
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
}
