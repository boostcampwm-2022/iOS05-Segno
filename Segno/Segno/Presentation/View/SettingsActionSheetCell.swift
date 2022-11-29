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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.shiningStar, size: Metric.labelFontSize)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubviews([titleLabel])
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.edgeSpacing)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func tapped(mode: SettingsActionSheetMode) {
        switch mode {
        case .darkmode:
            debugPrint("darkmode 관련 액션을 실행합니다.")
        }
    }
}
