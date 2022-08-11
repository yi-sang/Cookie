//
//  movieCell.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/08.
//

import UIKit
import Kingfisher

final class MovieCell: BaseCollectionViewCell {
    
    static let registerId = "\(MovieCell.self)"
    
    static let itemSize: CGSize = CGSize(width: (UIScreen.main.bounds.width - 10*2 - 30)/2,
                                         height: (UIScreen.main.bounds.width - 10*2 - 30)/2 * 1.5)
    
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
        $0.contentMode = .scaleAspectFill
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
            make.bottom.equalToSuperview().inset(25)
        }
        self.categoryImageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.categoryImageView.image = nil
    }
    
    func bind(movie: Movie) {
        self.titleLabel.text = movie.title
        if let url = URL(string: movie.posterPath) {
            if url == URL(string: "https://image.tmdb.org/t/p/original") {
                self.categoryImageView.contentMode = .scaleAspectFit
                self.categoryImageView.image = R.image.soloCookie()
            } else {
                self.categoryImageView.kf.setImage(with: url)
            }
        } else {
            self.categoryImageView.contentMode = .scaleAspectFit
            self.categoryImageView.image = R.image.soloCookie()
        }
    }
}
