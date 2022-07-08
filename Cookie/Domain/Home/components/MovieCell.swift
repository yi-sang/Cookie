//
//  movieCell.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/08.
//

import UIKit

final class MovieCell: BaseCollectionViewCell {
    static let registerId = "\(MovieCell.self)"
    
    static let itemSize: CGSize = CGSize(width: 175, height: 260)
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOpacity = 0.4
    }
    
    private let categoryImageView = UIImageView().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .jalnan(size: 14)
        $0.textColor = .black
        $0.sizeToFit()
        $0.textAlignment = .center
    }
    
    override func setup() {
        self.clipsToBounds = true

        self.addSubViews(
            self.containerView,
            self.categoryImageView,
            self.titleLabel
        )
    }
    
    override func bindConstraints() {
        self.containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
        self.categoryImageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalToSuperview()
        }
    }
    
    func bind(movie: Movie) {
        categoryImageView.downloadImageFrom(link: movie.posterPath, contentMode: .scaleAspectFill)
        titleLabel.text = movie.title
    }
}
