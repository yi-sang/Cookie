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

class HomeView: BaseView {
    var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    var contentView = UIView()
    
    var scrollViewConstraint: Constraint? = nil
        
    var verticalViewConstraint: Constraint? = nil
    
    var bannerViewConstraint: Constraint? = nil
    
    var bannerView = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)).then {
        $0.adUnitID = "ca-app-pub-1284586647851041/8398666241"
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
    }
    
    override func bindConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            scrollViewConstraint = $0.bottom.equalTo(self.safeAreaLayoutGuide).constraint
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
    }
    
    private func setupVerticalView(offset: CGFloat) {
        movieVerticalCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            verticalViewConstraint = $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-offset).constraint
        }
    }
    
    private func updateVerticalViewSubviews(offset: CGFloat) {
        verticalViewConstraint?.update(offset: -offset)
    }
    
    private func updateAdditionalBannerView(bottomHeight: CGFloat) {
        bannerViewConstraint?.update(offset: -bottomHeight)
    }
    
    private func setupBannerView() {
        self.bannerView.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.height.equalTo(50)
            $0.width.equalTo(UIScreen.main.bounds.width)
            bannerViewConstraint = $0.bottom.equalTo(self.safeAreaLayoutGuide).constraint
        }
    }
    
    private func scrollViewSetup(inset: CGFloat) {
        scrollViewConstraint?.update(offset: -inset)
    }
    
    func removeAdditionalSubviews() {
        self.movieVerticalCollectionView.removeFromSuperview()
        self.bannerView.removeFromSuperview()
    }
    
    func removeOriginSubviews() {
        self.contentView.removeFromSuperview()
        self.scrollView.removeFromSuperview()
        self.nowPlayingButton.removeFromSuperview()
        self.upcomingButton.removeFromSuperview()
        self.movieHorizontalCollectionView.removeFromSuperview()
        self.bannerView.removeFromSuperview()
    }

    func loadAdView() {
        self.bannerView.load(GADRequest())
        DispatchQueue.main.async {
            self.addSubview(self.bannerView)
            self.setupBannerView()
            self.scrollViewSetup(inset: 55)
        }
    }
    
    func loadNoAdView() {
            self.scrollViewSetup(inset: 0)
    }
    
    func setupAdditionalSubviews(status: Int) {
        self.addSubview(self.movieVerticalCollectionView)
        if status == 3 {
            self.addSubview(self.bannerView)
            self.setupVerticalView(offset: 55)
            self.setupBannerView()
        } else {
            self.setupVerticalView(offset: 5)
        }
    }
    
    func updateAdditionalSubviews(status: Int, offset: CGFloat) {
        if status == 3 {
            self.updateVerticalViewSubviews(offset: offset+55)
            self.updateAdditionalBannerView(bottomHeight: offset)
        } else {
            self.updateVerticalViewSubviews(offset: offset+5)
        }
    }
}
