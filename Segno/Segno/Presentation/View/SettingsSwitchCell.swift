//
//  SettingsCell.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/28.
//

import UIKit

import SnapKit

final class SettingsSwitchCell: UITableViewCell {
    private enum Metric {
        static let edgeSpacing: CGFloat = 20
        static let labelFontSize: CGFloat = 20
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.shiningStar, size: Metric.labelFontSize)
        return label
    }()
    
    lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
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
    
    func configure(title: String, isOn: Bool, row: Int) {
        titleLabel.text = title
        switchButton.isOn = isOn
        switchButton.tag = row
    }
    
    @objc private func switchButtonTapped() {
        switch switchButton.tag {
        case 1:
            debugPrint("\(switchButton.isOn) / autoPlay 관련 액션을 실행합니다.")
        default:
            break
        }
    }
}
