//
//  Slider.swift
//  Cookie
//
//  Created by 이상현 on 2022/08/03.
//

import UIKit

final class Slider: UISlider {

    private let baseLayer = CALayer()
    private let trackLayer = CAGradientLayer()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }

    private func setup() {
        clear()
        createBaseLayer()
        configureTrackLayer()
    }

    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }

    private func createBaseLayer() {
        baseLayer.borderWidth = 1
        baseLayer.borderColor = UIColor.lightGray.cgColor
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor.white.cgColor
        baseLayer.frame = .init(x: 0,
                                y: frame.height / 4,
                                width: frame.width,
                                height: frame.height)
        baseLayer.cornerRadius = baseLayer.frame.height / 2
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    private func configureTrackLayer() {
        let firstColor = UIColor.red.cgColor
        let secondColor = UIColor.yellow.cgColor
        trackLayer.colors = [firstColor, secondColor]
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = .init(x: 0, y: frame.height / 4, width: 0, height: frame.height)
        trackLayer.cornerRadius = trackLayer.frame.height / 2
        layer.insertSublayer(trackLayer, at: 1)
    }
    
    func valueChanged() {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let thumbRectA = thumbRect(forBounds: bounds,
                                       trackRect: trackRect(forBounds: bounds),
                                       value: value)
            trackLayer.frame = .init(x: 0,
                                     y: frame.height / 4,
                                     width: thumbRectA.maxX,
                                     height: frame.height)
            CATransaction.commit()
    }
}
