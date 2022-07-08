//
//  UIFontExtension.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/08.
//

import UIKit

extension UIFont {
    static func jalnan(size: CGFloat) -> UIFont? {
        return Self.init(name: "Jalnan", size: size)
    }
    
    static func regular(size: CGFloat) -> UIFont? {
        return Self.init(name: "NotoSansKR-Regular", size: size)
    }
    
    static func medium(size: CGFloat) -> UIFont? {
        return Self.init(name: "NotoSansKR-Medium", size: size)
    }
    
    static func bold(size: CGFloat) -> UIFont? {
        return Self.init(name: "NotoSansKR-Bold", size: size)
    }
}
