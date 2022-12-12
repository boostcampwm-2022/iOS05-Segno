//
//  SettingsCell.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/28.
//

import UIKit

import RxSwift
import SnapKit

final class SettingsSwitchCell: UITableViewCell {
    private enum Metric {
        static let edgeSpacing: CGFloat = 20
        static let labelFontSize: CGFloat = 16
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Metric.labelFontSize)
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        return switchButton
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
        contentView.addSubviews([titleLabel, switchButton])
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.edgeSpacing)
        }
        
        switchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Metric.edgeSpacing)
        }
    }
    
    func configure(title: String, isOn: Bool, action: SettingsCellActions) {
        titleLabel.text = title
        switchButton.isOn = isOn
        switchButton.tag = action.toRow
    }
}
