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
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        print("someting@@@@@")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = self.detailRector
        self.reactor?.action.onNext(.viewDidLoad(id: movie.id))
        self.setupUI()
        self.scrollRandomly()
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
        self.detailView.foldButton.rx.tap
            .asDriver()
            .drive(onNext:  { [weak self] in
                guard let self = self else { return }
                if self.detailView.foldButton.isSelected {
                    self.detailView.decreaseConstraint()
                } else {
                    self.detailView.increaseConstraint()
                }
                self.detailView.foldButton.isSelected.toggle()
            })
            .disposed(by: eventDisposeBag)
    }
    
    func bind(reactor: DetailReactor) {
        self.detailView.imageButton.rx.tap
            .asDriver()
            .drive(onNext:  { _ in
                reactor.action.onNext(.imageButtonClicked)
            })
            .disposed(by: disposeBag)
        
        self.detailView.noCookieButton.rx.tap
            .asDriver()
            .drive(onNext:  { [weak self] _ in
                guard let self = self else { return }
                reactor.action.onNext(.noCookieClicked(id: self.movie.id))
            })
            .disposed(by: disposeBag)
        
        self.detailView.oneCookieButton.rx.tap
            .asDriver()
            .drive(onNext:  { [weak self] _ in
                guard let self = self else { return }
                reactor.action.onNext(.oneCookieClicked(id: self.movie.id))
            })
            .disposed(by: disposeBag)
        
        self.detailView.twoCookieButton.rx.tap
            .asDriver()
            .drive(onNext:  { [weak self] _ in
                guard let self = self else { return }
                reactor.action.onNext(.twoCookieClicked(id: self.movie.id))
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.tapped }
            .filter { $0 == 15 }
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { _ in
                reactor.action.onNext(.success)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.key }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: { [weak self] key in
                guard let self = self else { return }
                if key == "-" {
                    reactor.action.onNext(.retry(id: self.movie.id))
                } else {
                    self.detailView.playerView.load(withVideoId: key!)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.newKey }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: { [weak self] newKey in
                guard let self = self else { return }
                guard let newKey = newKey else { return }
                self.detailView.playerView.load(withVideoId: newKey)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.totalCookie }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: TotalCookie())
            .drive(onNext: { [weak self] totalCookie in
                guard let self = self else { return }
                guard let totalCookie = totalCookie else { return }
                self.setTotalButton(totalCookie: totalCookie)
                self.setPickerView(totalCookie: totalCookie)
                self.setImage(totalCookie: totalCookie)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.user }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: User())
            .drive(onNext: { [weak self] user in
                guard let self = self else { return }
                guard let user = user else { return }
                let level = Int(user.experience / 10) + 1
                let experience = Float(user.experience % 10)
                if experience == 0.0 && user.direction {
                    self.detailView.slider.value = experience + 10
                    self.detailView.slider.valueChanged()
                    self.detailView.experienceLabel.text = "기여도 lv.\(level-1)"
                    self.shake(view: self.detailView.slider, completion: {
                        self.detailView.slider.value = experience
                        self.detailView.slider.valueChanged()
                        self.detailView.experienceLabel.text = "기여도 lv.\(level)"
                    })
                } else {
                    self.detailView.slider.value = experience
                    self.detailView.slider.valueChanged()
                    self.detailView.experienceLabel.text = "기여도 lv.\(level)"
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        let releaseDate = movie.releaseDate.replacingOccurrences(of: "-", with: ".")
        self.detailView.titleLabel.text = movie.title
        self.detailView.releaseDateLabel.text = "\(releaseDate) 개봉"
        self.detailView.overViewLabel.text = movie.overview
        self.detailView.playerView.load(withVideoId: "")
    }
    
    private func setButton(button: UIButton, isSelected: Bool) {
        button.isUserInteractionEnabled = isSelected

        if isSelected {
            button.layer.opacity = 1
        } else {
            button.layer.opacity = 0.5
        }
    }
    
    private func setTotalButton(totalCookie: TotalCookie) {
        if totalCookie.personal.contains(Cookie(uuid: Storage.shared.uuid, cookieType: 0)) {
            self.setButton(button: self.detailView.noCookieButton, isSelected: true)
            self.setButton(button: self.detailView.oneCookieButton, isSelected: false)
            self.setButton(button: self.detailView.twoCookieButton, isSelected: false)
        } else if totalCookie.personal.contains(Cookie(uuid: Storage.shared.uuid, cookieType: 1)) {
            self.setButton(button: self.detailView.noCookieButton, isSelected: false)
            self.setButton(button: self.detailView.oneCookieButton, isSelected: true)
            self.setButton(button: self.detailView.twoCookieButton, isSelected: false)
        } else if totalCookie.personal.contains(Cookie(uuid: Storage.shared.uuid, cookieType: 2)) {
            self.setButton(button: self.detailView.noCookieButton, isSelected: false)
            self.setButton(button: self.detailView.oneCookieButton, isSelected: false)
            self.setButton(button: self.detailView.twoCookieButton, isSelected: true)
        } else {
            self.setButton(button: self.detailView.noCookieButton, isSelected: true)
            self.setButton(button: self.detailView.oneCookieButton, isSelected: true)
            self.setButton(button: self.detailView.twoCookieButton, isSelected: true)
        }
    }
    
    private func setPickerView(totalCookie: TotalCookie) {
        let smallestValue: Int = min(totalCookie.noClue, totalCookie.noCookie, totalCookie.oneCookie, totalCookie.twoCookie)
        
        let biggestValue: Int = max(totalCookie.noClue, totalCookie.noCookie, totalCookie.oneCookie, totalCookie.twoCookie)
        
        let sumValue = totalCookie.noCookie + totalCookie.oneCookie + totalCookie.twoCookie
        
        let difference = (biggestValue - smallestValue) % 10
        if sumValue != 0 {
            if difference < 1 {
                self.detailView.pickerView.selectRow(4, inComponent: 0, animated: true)
            } else if difference < 3 {
                self.detailView.pickerView.selectRow(0, inComponent: 0, animated: true)
            } else if difference < 5 {
                self.detailView.pickerView.selectRow(1, inComponent: 0, animated: true)
            } else if difference < 7 {
                self.detailView.pickerView.selectRow(2, inComponent: 0, animated: true)
            } else if difference < 10 {
                self.detailView.pickerView.selectRow(3, inComponent: 0, animated: true)
            } else if difference > 10 {
                self.detailView.pickerView.selectRow(4, inComponent: 0, animated: true)
            }
        } else {
            self.detailView.pickerView.selectRow(4, inComponent: 0, animated: true)
        }
    }
    
    private func setImage(totalCookie: TotalCookie) {
        let biggestValue: Int = max(totalCookie.noClue, totalCookie.noCookie, totalCookie.oneCookie, totalCookie.twoCookie)
        if biggestValue == totalCookie.noClue {
            self.detailView.imageButton.configuration?.title = ""
            self.detailView.imageButton.configuration?.attributedTitle!.font =  .jalnan(size: 20)
            self.detailView.imageButton.configuration?.image = R.image.noClue()?.resizeImage(size: CGSize(width: 150, height: 150))
        } else if biggestValue == totalCookie.noCookie {
            self.detailView.imageButton.configuration?.title = "쿠키 없음"
            self.detailView.imageButton.configuration?.attributedTitle!.font =  .jalnan(size: 20)
            self.detailView.imageButton.configuration?.image = R.image.dish()?.resizeImage(size: CGSize(width: 150, height: 150))
        } else if biggestValue == totalCookie.oneCookie {
            self.detailView.imageButton.configuration?.title = "쿠키 하나"
            self.detailView.imageButton.configuration?.attributedTitle!.font =  .jalnan(size: 20)
            self.detailView.imageButton.configuration?.image = R.image.oneCookie()?.resizeImage(size: CGSize(width: 150, height: 150))
        } else if biggestValue == totalCookie.twoCookie {
            self.detailView.imageButton.configuration?.title = "쿠키 두개"
            self.detailView.imageButton.configuration?.attributedTitle!.font =  .jalnan(size: 20)
            self.detailView.imageButton.configuration?.image = R.image.twoCookie()?.resizeImage(size: CGSize(width: 150, height: 150))
        }
    }
    
    private func scrollRandomly() {
        let row:Int = .random(in: 0..<5)
        self.detailView.pickerView.selectRow(row, inComponent: 0, animated: true)
     }
    
    private func shake(view: UIView, completion: (@escaping ()->Void)) {
        UIView.animate(withDuration: 0.1, animations: {
            view.bounds.origin.y -= 20

        }, completion: { bool in
            if bool {
                UIView.animate(withDuration: 0.2, animations: {
                    view.bounds.origin.y += 40
                }, completion: { bool in
                    if bool {
                        UIView.animate(withDuration: 0.1, animations: {
                            view.bounds.origin.y -= 20
                        }, completion: { bool in
                            if bool {
                                completion()
                            }
                        })
                    }
                })
            }
        })
    }
}
