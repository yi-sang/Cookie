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
    var nowPlayingButton = UIButton().then{
        $0.setTitle("상영중인 영화", for: .normal)
        $0.setTitleColor(.black, for: .selected)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = .jalnan(size: 16)
    }
    
    var upcomingButton = UIButton().then{
        $0.setTitle("개봉 예정 영화", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.darkGray, for: .selected)
        $0.titleLabel?.font = .jalnan(size: 16)
    }

    let movieCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = HomeFlowLayout()
        
        layout.scrollDirection = .horizontal
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
        self.addSubViews(
            nowPlayingButton,
            upcomingButton,
            movieCollectionView
        )
    }
    
    override func bindConstraints() {
        nowPlayingButton.snp.makeConstraints {
            $0.top.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
        }
        upcomingButton.snp.makeConstraints {
            $0.top.equalTo(nowPlayingButton)
            $0.leading.equalTo(nowPlayingButton.snp.trailing).offset(15)
        }
        movieCollectionView.snp.makeConstraints {
            $0.top.equalTo(nowPlayingButton.snp.bottom).offset(10)
            $0.leading.trailing.width.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(((UIScreen.main.bounds.width - 10*4 - 20)/2 * 1.5)*2 + 10)
        }
    }
}
