//
//  ViewController.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/09.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class LoginViewController: UIViewController {
    
    // MARK: - Property
    private let disposeBag = DisposeBag()
    
    private enum Metric {
        static let googleTitle = "구글 로그인"
        static let appleTitle = "애플 로그인"
        
        static let titleText = "Segno"
        static let subTitleText = "다시 이곳의 추억에서부터"
        static let footerText = "D.S."
        
        static let spacingBetweenButtons: CGFloat = 20
        static let inset: CGFloat = 20
     
        static let titleHeight: CGFloat = 100
        static let titleOffset: CGFloat = 200
        static let subTitleHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 50
    }
    
    // MARK: - View
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = Metric.titleText
        
        // TODO: Apply color, font
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = Metric.subTitleText
        
        // TODO: Apply color, font
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Metric.googleTitle, for: .normal)
        
        // TODO: Apply color, font
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Metric.appleTitle, for: .normal)
        
        // TODO: Apply color, font
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        
        return button
    }()
    
    private lazy var buttonStack = {
        let stackView = UIStackView()
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Metric.inset
        
        return stackView
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        
        // TODO: Apply color, font
        label.text = Metric.footerText
        label.textAlignment = .right
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupRx()
    }
    
    // MARK: - Private
    
    private func setupRx() {
        googleButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                // TODO: Bind with Google Login Button Action
                print("google")
            }
            .disposed(by: disposeBag)
        
        appleButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                // TODO: Bind with Apple Login Button Action
                print("apple")
            }
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
    }
    
    private func setupLayout() {
        [googleButton, appleButton].forEach {
            buttonStack.addArrangedSubview($0)
        }
        
        [titleLabel, subTitleLabel, buttonStack, footerLabel].forEach {
            view.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.width.equalToSuperview().inset(Metric.inset)
                make.centerX.equalTo(view.snp.centerX)
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(Metric.titleHeight)
            make.top.equalToSuperview().offset(Metric.titleOffset)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(Metric.subTitleHeight)
        }
        
        footerLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-100)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        buttonStack.arrangedSubviews.forEach {
            $0.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(Metric.buttonHeight)
            }
        }
    }
    
    // MARK: - Public
    
}
