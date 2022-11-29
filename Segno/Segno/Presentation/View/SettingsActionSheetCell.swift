//
//  SettingsActionSheetCell.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/29.
//


import UIKit

import SnapKit

enum SettingsActionSheetMode {
    case darkmode
}

final class SettingsActionSheetCell: UITableViewCell {
    private enum Metric {
        static let labelFontSize: CGFloat = 20
        static let edgeSpacing: CGFloat = 20
    }
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.shiningStar, size: Metric.labelFontSize)
        return label
    }()
    
    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.shiningStar, size: Metric.labelFontSize)
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.shiningStar, size: Metric.labelFontSize)
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
        contentView.addSubviews([leftLabel, centerLabel, rightLabel])
        
        leftLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.edgeSpacing)
        }
        
        centerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Metric.edgeSpacing)
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
    
    func tapped(mode: SettingsActionSheetMode) {
        switch mode {
        case .darkmode:
            debugPrint("darkmode 관련 액션을 실행합니다.")
        }
    }
}
