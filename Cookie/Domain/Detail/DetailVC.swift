//
//  DetailVC.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/18.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class DetailVC: BaseVC, View {
    private let detailRector = DetailReactor(
        movieService: MovieService()
    )
    
    private var detailView = DetailView()
        
    
    var movie = Movie()

    override func loadView() {
        self.view = self.detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = self.detailRector
        self.reactor?.action.onNext(.viewDidLoad(id: movie.id))
        setupUI()
    }
    
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
    
    override func bindEvent() {
    }
    
    func bind(reactor: DetailReactor) {
        reactor.state
            .map { $0.key }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: { [weak self] key in
                guard let self = self else { return }
                if key == "" {
                    reactor.action.onNext(.retry(id: self.movie.id))
                
                } else {
                    self.detailView.playerView.load(withVideoId: key)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.newKey }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: { [weak self] key in
                guard let self = self else { return }
                
                self.detailView.playerView.load(withVideoId: key)
            })
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
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
        self.detailView.playerView.load(withVideoId: "")
    }
}
