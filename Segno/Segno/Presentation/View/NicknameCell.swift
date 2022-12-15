//
//  NicknameCell.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/28.
//

import UIKit

import RxSwift

final class NicknameCell: UITableViewCell {
    // MARK: - Namespaces
    private enum Metric {
        static let buttonWidth: CGFloat = 70
        static let cornerRadius: CGFloat = 8
        static let edgeSpacing: CGFloat = 16
        static let leftViewSpacing: CGFloat = 16
        static let nicknameViewHeight: CGFloat = 100
        static let nicknameViewWidth: CGFloat = UIScreen.main.bounds.width
        static let textHeight: CGFloat = 40
        static let textSize: CGFloat = 14
    }
    
    private enum Literal {
        static let nicknameLabelText: String = "닉네임 변경"
        static let textfieldPlaceholder: String = "사용할 닉네임을 입력해주세요"
        static let buttonText: String = "확인"
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Views
    private lazy var nicknameView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Metric.nicknameViewWidth, height: Metric.nicknameViewHeight))
        return view
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Metric.textSize)
        label.text = Literal.nicknameLabelText
        label.textColor = .appColor(.grey3)
        return label
    }()
    
    lazy var nicknameTextField: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .appColor(.grey1)
        textfield.layer.cornerRadius = Metric.cornerRadius
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Metric.leftViewSpacing, height: 0))
        textfield.leftViewMode = .always
        textfield.placeholder = Literal.textfieldPlaceholder
        return textfield
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color4)
        button.layer.cornerRadius = Metric.cornerRadius
        button.setTitle(Literal.buttonText, for: .normal)
        button.setTitleColor(.appColor(.white), for: .normal)
        return button
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: View setup methods
    private func setupView() {
        self.backgroundColor = .appColor(.background)
    }
    
    private func setupLayout() {
        contentView.addSubview(nicknameView)
        nicknameView.addSubviews([nicknameLabel, nicknameTextField, okButton])
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.top.equalTo(nicknameView).inset(Metric.edgeSpacing)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Metric.edgeSpacing)
            $0.leading.equalTo(nicknameView).inset(Metric.edgeSpacing)
            $0.trailing.equalTo(okButton.snp.leading).offset(-Metric.edgeSpacing)
            $0.height.equalTo(Metric.textHeight)
        }
        
        okButton.snp.makeConstraints {
            $0.width.equalTo(Metric.buttonWidth)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Metric.edgeSpacing)
            $0.trailing.equalTo(nicknameView).inset(Metric.edgeSpacing)
            $0.height.equalTo(Metric.textHeight)
        }
    }
}
