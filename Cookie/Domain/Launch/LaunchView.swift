//
//  LaunchView.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//
import UIKit
import Then
import SnapKit
import Lottie
class LaunchView: BaseView {
    let lottie = AnimationView(name: "EatingCookie").then {
        $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        $0.contentMode = .scaleAspectFit
        $0.animationSpeed = 2.0
        $0.alpha = 1
    }
    
    let logo = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = R.image.logoCookie()
        $0.alpha = 0
    }
    
    override func setup() {
        addSubViews(
            lottie,
            logo
        )
    }
    
    override func bindConstraints() {
        self.lottie.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.logo.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(40)
        }
    }
    
    func startAnimation(completion: @escaping (() -> Void)) {
        self.lottie.play { [weak self] _ in
            self?.lottie.alpha = 0.0
            self?.logo.alpha = 1.0
            UIView.animate (
                withDuration: 0.3,
                animations: {
                    self?.logo.transform = CGAffineTransform(rotationAngle: (self?.radians(degrees: 30))!)
                }) { (true) in
                    UIView.animate (
                        withDuration: 0.3,
                        animations: {
                            self?.logo.transform = CGAffineTransform(rotationAngle: (self?.radians(degrees: -30))!)
                        }) { (true) in
                            UIView.animate (
                                withDuration: 0.3,
                                animations: {
                                    self?.logo.transform = CGAffineTransform(rotationAngle: (self?.radians(degrees: 0))!)
                                }) { (true) in
                                    completion()
                                }
                        }
                }
        }
    }
    
    private func radians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180)
    }
}
