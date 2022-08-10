//
//  HomeView.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/04/30.
//

import UIKit
import Then
import SnapKit
import GoogleMobileAds
import AppTrackingTransparency

class HomeView: BaseView {
    var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    var contentView = UIView()
    
    var virticalCollectionViewBottomConstraint: Constraint? = nil

    var bannerView = GADBannerView(adSize: GADAdSizeBanner).then {
        $0.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    }
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "영화 제목을 검색해보세요"
        $0.searchTextField.tintColor = .clear
        $0.setShowsCancelButton(false, animated: false)
        $0.setValue("취소", forKey: "cancelButtonText")
        $0.tintColor = .black
    }
    
    let nowPlayingButton = UIButton().then{
        $0.setTitle("상영중인 영화", for: .normal)
        $0.setTitleColor(.black, for: .selected)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = .jalnan(size: 16)
        $0.sizeToFit()
    }
    
    let upcomingButton = UIButton().then{
        $0.setTitle("개봉 예정 영화", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.darkGray, for: .selected)
        $0.titleLabel?.font = .jalnan(size: 16)
        $0.sizeToFit()
    }

    let movieHorizontalCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = HomeHorizontalFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = MovieCell.itemSize
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.register(
            MovieCell.self,
            forCellWithReuseIdentifier: MovieCell.registerId
        )
    }
    
    let movieVerticalCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = SearchMovieCell.itemSize
        $0.showsVerticalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.register(
            SearchMovieCell.self,
            forCellWithReuseIdentifier: SearchMovieCell.registerId
        )
    }
    
    override func setup() {
        self.addSubViews(
            scrollView
        )
        scrollView.addSubview(
            contentView
        )
        contentView.addSubViews(
            nowPlayingButton,
            upcomingButton,
            movieHorizontalCollectionView
        )
        self.loadAd()
    }
    
    override func bindConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-50)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
        }
        
        nowPlayingButton.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.leading.equalTo(contentView).offset(15)
        }
        upcomingButton.snp.makeConstraints {
            $0.top.equalTo(nowPlayingButton)
            $0.leading.equalTo(nowPlayingButton.snp.trailing).offset(15)
            $0.trailing.lessThanOrEqualTo(contentView)
        }
        movieHorizontalCollectionView.snp.makeConstraints {
            $0.top.equalTo(nowPlayingButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(((UIScreen.main.bounds.width - 10*4 - 10)/2 * 1.5)*2 + 10)
            $0.bottom.equalTo(contentView).offset(-5)
        }
        addBannerViewToView(bannerView, bottomHeight: 0)
    }
    
    func additionalSetup() {
        self.addSubview(self.movieVerticalCollectionView)
        movieVerticalCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.width.equalTo(self.safeAreaLayoutGuide)
            virticalCollectionViewBottomConstraint = $0.bottom.equalTo(self.safeAreaLayoutGuide).constraint
        }
    }
    
    func updateAdditionalSetup(offset: CGFloat) {
        self.virticalCollectionViewBottomConstraint?.update(inset: offset)
    }
    
    func removeSubviews() {
        self.nowPlayingButton.removeFromSuperview()
        self.upcomingButton.removeFromSuperview()
        self.movieHorizontalCollectionView.removeFromSuperview()
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView, bottomHeight: CGFloat) {
        self.addSubview(bannerView)
        bannerView.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.height.equalTo(50)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-bottomHeight)
        }
    }
    
    private func loadAd() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.bannerView.load(GADRequest())
                    }
                }
            })
        } else {
            DispatchQueue.main.async {
                self.bannerView.load(GADRequest())
            }
        }
    }
}
