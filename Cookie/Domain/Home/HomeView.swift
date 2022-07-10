//
//  HomeView.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/04/30.
//

import UIKit
import Then
import SnapKit

class HomeView: BaseView {
    let scrollView = UIScrollView().then{ _ in }
    let contentView = UIView().then{ _ in }
    let nowPlayingLabel = UILabel().then{
        $0.text = "상영중인 영화"
        $0.textColor = .black
        $0.font = .jalnan(size: 16)
    }
    let upcomingLabel = UILabel().then{
        $0.text = "개봉 예정 영화"
        $0.textColor = .black
        $0.font = .jalnan(size: 16)
    }

    let upcomingMovieCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = HomeStoreFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 17
        layout.itemSize = MovieCell.itemSize
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.register(
            MovieCell.self,
            forCellWithReuseIdentifier: MovieCell.registerId
        )
    }
    
    let nowPlayingMovieCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = HomeStoreFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 17
        layout.itemSize = MovieCell.itemSize
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.register(
            MovieCell.self,
            forCellWithReuseIdentifier: MovieCell.registerId
        )
    }
    
    override func setup() {
        self.backgroundColor = .white
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(nowPlayingLabel)
        contentView.addSubview(nowPlayingMovieCollectionView)
        contentView.addSubview(upcomingLabel)
        contentView.addSubview(upcomingMovieCollectionView)
    }
    
    override func bindConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
            $0.bottom.equalTo(upcomingMovieCollectionView)
        }
        nowPlayingLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.leading.equalTo(contentView).offset(15)
        }
        nowPlayingMovieCollectionView.snp.makeConstraints {
            $0.top.equalTo(nowPlayingLabel).offset(20)
            $0.leading.trailing.width.equalTo(scrollView)
            $0.height.equalTo(260)
        }
        upcomingLabel.snp.makeConstraints {
            $0.top.equalTo(nowPlayingMovieCollectionView.snp.bottom).offset(20)
            $0.leading.equalTo(contentView).offset(15)
        }
        upcomingMovieCollectionView.snp.makeConstraints {
            $0.top.equalTo(upcomingLabel.snp.bottom).offset(20)
            $0.leading.trailing.width.equalTo(scrollView)
            $0.height.equalTo(260)
        }
    }
}
