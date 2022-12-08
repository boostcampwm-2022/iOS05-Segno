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
        static let tagFontSize: CGFloat = 12
        static let tagInset: CGFloat = 9
        static let cornerRadius: CGFloat = 15
    }

    lazy var tagLabel: UILabel = {
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
        backgroundColor = .appColor(.color4)
        layer.cornerRadius = Metric.cornerRadius
        
        tagLabel.text = tagTitle
        tagLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.tagInset)
            $0.centerY.equalTo(self.snp.centerY)
        }
        
    }
}
