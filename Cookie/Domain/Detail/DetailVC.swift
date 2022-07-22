//
//  DetailVC.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/18.
//

import UIKit

final class DetailVC: BaseVC {
    private let detailView = DetailView()
    var movie = Movie()
    
    static func instance(movie: Movie) -> DetailVC {
        return DetailVC(movie: movie).then {
            $0.modalPresentationStyle = .pageSheet
            $0.modalTransitionStyle = .coverVertical
        }
    }
    
    init(movie: Movie) {
        self.movie = movie
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie.posterPath)
        if let url = URL(string: movie.posterPath) {
            if url == URL(string: "https://image.tmdb.org/t/p/original") {

                self.detailView.imageView.image = R.image.oneCookie()

            } else {

                self.detailView.imageView.kf.setImage(with: url)

            }
        } else {
            self.detailView.imageView.image = R.image.oneCookie()
        }
        self.detailView.titleLabel.text = movie.title
        self.detailView.overViewLabel.text = movie.overview
        

    }
    
    override func bindEvent() {
        
    }
    
    override func bindViewModelOutput() {
        
    }
}

