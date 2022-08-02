//
//  SearchButton.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/15.
//
import UIKit
import SnapKit
import Then

final class SearchButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        var configuration = UIButton.Configuration.gray()
        configuration.imagePadding = 6
        configuration.baseBackgroundColor = UIColor(rgb: 0xECECEE)
        configuration.title = "영화 제목을 검색해보세요"
        configuration.baseForegroundColor = .gray
        configuration.image = UIImage(systemName: "magnifyingglass")?.resizeImage(size: CGSize(width: 20+1/3, height: 18+2/3)).withRenderingMode(.alwaysTemplate)
        self.layer.cornerRadius = 13
        self.contentHorizontalAlignment = .leading
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
