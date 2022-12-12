//
//  SettingsActionSheetCell.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/29.
//


import UIKit

import RxSwift
import SnapKit

final class SettingsActionSheetCell: UITableViewCell {
    private enum Metric {
        static let labelFontSize: CGFloat = 16
        static let edgeSpacing: CGFloat = 20
        static let cellWidth: CGFloat = UIScreen.main.bounds.width
        static let cellHeight: CGFloat = 44
    }
    
    private lazy var labelView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Metric.cellWidth, height: Metric.cellHeight))
        return view
    }()
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Metric.labelFontSize)
        return label
    }()
    
    private lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Metric.labelFontSize)
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Metric.labelFontSize)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupLayout()
    }
    
    private func setupView() {
        self.backgroundColor = .appColor(.background)
    }
    
    private func setupLayout() {
        contentView.addSubview(labelView)
        
        labelView.addSubviews([leftLabel, centerLabel, rightLabel])
        
        leftLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(labelView)
            $0.leading.equalTo(labelView).inset(Metric.edgeSpacing)
        }
        
        centerLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(labelView)
            $0.centerX.equalTo(labelView)
        }
        
        rightLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(labelView)
            $0.trailing.equalTo(labelView).inset(Metric.edgeSpacing)
        }
    }
    
    func configure(left: String? = nil, center: String? = nil, right: String? = nil, color: UIColor? = nil) {
        if let left = left { leftLabel.text = left }
        if let center = center { centerLabel.text = center }
        if let right = right { rightLabel.text = right }
        if let color = color {
            leftLabel.textColor = color
            centerLabel.textColor = color
            rightLabel.textColor = color
        }
    }
}
