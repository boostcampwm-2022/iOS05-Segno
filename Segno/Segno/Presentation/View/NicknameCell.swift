//
//  NicknameCell.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/28.
//

import UIKit

final class NicknameCell: UITableViewCell {
    private enum Metric {
        static let edgeSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 8
        static let textHeight: CGFloat = 40
        static let textSize: CGFloat = 14
    }
    
    private lazy var nicknameView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 변경"
        label.font = .appFont(.surroundAir, size: Metric.textSize)
        label.textColor = .appColor(.grey2)
        return label
    }()
    
    lazy var nicknameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "사용할 닉네임을 입력해주세요"
        textfield.backgroundColor = .appColor(.grey1)
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textfield.leftViewMode = .always
        textfield.layer.cornerRadius = Metric.cornerRadius
        return textfield
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .appColor(.color4)
        button.setTitleColor(.appColor(.white), for: .normal)
        button.layer.cornerRadius = Metric.cornerRadius
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(nicknameView)
        nicknameView.addSubviews([nicknameLabel, nicknameTextField, okButton])
        
        nicknameView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(100)
        }
        
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
            $0.width.equalTo(70)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Metric.edgeSpacing)
            $0.trailing.equalTo(nicknameView).inset(Metric.edgeSpacing)
            $0.height.equalTo(Metric.textHeight)
        }
    }
    
    @objc private func okButtonTapped() {
        debugPrint("\(nicknameTextField.text!) - 확인 버튼을 누름")
    }
}
