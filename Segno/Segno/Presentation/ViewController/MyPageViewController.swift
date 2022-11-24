//
//  MyPageViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class MyPageViewController: UIViewController {
    private enum Metric {
        static let titleText: String = "안녕하세요,\nboostcamp님!"
        
        static let buttonFontSize: CGFloat = 15
        static let buttonHeight: CGFloat = 50
        static let settingsOffset: CGFloat = 100
        static let stackViewSpacing: CGFloat = 1
        static let titleFontSize: CGFloat = 32
        static let titleOffset: CGFloat = 30
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surround, size: Metric.titleFontSize)
        label.numberOfLines = 0
        label.text = Metric.titleText
        return label
    }()
    
    lazy var settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var diaryCountButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성한 일기 수 : 123,456,789개", for: .normal)
        button.setTitleColor(.appColor(.black), for: .normal)
        button.titleLabel?.font = .appFont(.surroundAir, size: Metric.buttonFontSize)
        button.setBackgroundColor(.appColor(.color1) ?? .red, for: .normal)
        return button
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("설정", for: .normal)
        button.setTitleColor(.appColor(.black), for: .normal)
        button.titleLabel?.font = .appFont(.surroundAir, size: Metric.buttonFontSize)
        button.setBackgroundColor(.appColor(.color1) ?? .red, for: .normal)
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .appFont(.surroundAir, size: Metric.buttonFontSize)
        button.setBackgroundColor(.appColor(.color1) ?? .red, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }

    private func setupView() {
        view.backgroundColor = .appColor(.background)
    }
    
    private func setupLayout() {
        [titleLabel, settingsStackView].forEach {
            view.addSubview($0)

            $0.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.centerX.equalTo(view.snp.centerX)
            }
        }
        
        [diaryCountButton, settingButton, logoutButton].forEach {
            settingsStackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(Metric.buttonHeight)
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(Metric.titleOffset)
        }
        
        settingsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.settingsOffset)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageViewController_Preview: PreviewProvider {
    static var previews: some View {
        MyPageViewController().showPreview(.iPhone14Pro)
    }
}
#endif
