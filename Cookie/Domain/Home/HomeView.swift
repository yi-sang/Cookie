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
    let textLabel = UILabel().then {
        $0.text = "qq"
        $0.textColor = .red
    }
    
    override func setup() {
        self.backgroundColor = .white
        self.addSubview(textLabel)
    }
    
    override func bindConstraints() {
        textLabel.snp.makeConstraints {
            $0.center.equalTo(self.snp.center)
        }
    }
}
