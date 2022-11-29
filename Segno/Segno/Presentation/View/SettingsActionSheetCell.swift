//
//  SettingsActionSheetCell.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/29.
//


import UIKit

import RxSwift
import SnapKit

enum SettingsActionSheetMode {
    case darkmode
}

final class SettingsActionSheetCell: UITableViewCell {
    private enum Metric {
        static let labelFontSize: CGFloat = 20
        static let edgeSpacing: CGFloat = 20
    }
    
    var settingsActionSheetTapped = PublishSubject<(SettingsActionSheetMode, Any?)>()
    
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
    
    func tapped(mode: SettingsActionSheetMode, _ completionHandler: @escaping (UIAlertController) -> Void) {
        switch mode {
        case .darkmode:
            let actionSheet = UIAlertController(title: "다크 모드 설정", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "시스템 설정", style: .default, handler: { _ in
                self.settingsActionSheetTapped.onNext((.darkmode, 0))
            }))
            actionSheet.addAction(UIAlertAction(title: "항상 밝게", style: .default, handler: { _ in
                self.settingsActionSheetTapped.onNext((.darkmode, 1))
            }))
            actionSheet.addAction(UIAlertAction(title: "항상 어둡게", style: .default, handler: { _ in
                self.settingsActionSheetTapped.onNext((.darkmode, 2))
            }))
            completionHandler(actionSheet)
        }
    }
}
