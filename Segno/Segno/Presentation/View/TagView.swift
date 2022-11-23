//
//  TagView.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/22.
//

import UIKit
import SnapKit

final class TagView: UIView {
    private enum Metric {
        static let tagFontSize: CGFloat = 16
    }

    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surround, size: Metric.tagFontSize)
        label.textColor = .appColor(.white)
        return label
    }()
    
    init(tagTitle: String) {
        super.init(frame: CGRect())
    
        setupLayout(tagTitle: tagTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(tagTitle: String) {
        addSubview(tagLabel)
        backgroundColor = .appColor(.color3)
        tagLabel.text = tagTitle
        tagLabel.snp.makeConstraints {
            $0.width.equalTo(self.snp.width)
            $0.centerY.equalTo(self.snp.centerY)
        }
    }
}
