//
//  ViewController.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/09.
//

import AuthenticationServices
import UIKit

import RxCocoa
import RxSwift
import SnapKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginDidSucceed()
    func loginDidFail()
}

final class LoginViewController: UIViewController {
    
    // MARK: - Property
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    weak var delegate: LoginViewControllerDelegate?
    
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
        static let buttonRadius: CGFloat = 20
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
        label.textColor = .systemGray
        
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
        label.textColor = .systemGray4
        
        return label
    }()
    
    // MARK: - initializer
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not imported")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupRx()
        
//        testSubscribe()
    }
    
    // MARK: - Private
    
    private func testSubscribe() {
        viewModel.isLoginSucceeded
            .subscribe(onNext: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case true:
                        self?.titleLabel.backgroundColor = .blue
                        // TODO: 유저 정보를 넣어 줍시다.
                        self?.delegate?.loginDidSucceed()
                    case false:
                        self?.titleLabel.backgroundColor = .orange
                        self?.delegate?.loginDidFail()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupRx() {
        googleButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                print("google")
                self.googleButtonTapped()
            }
            .disposed(by: disposeBag)
        
        appleButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                print("apple")
                self.appleButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        
        googleButton.layer.cornerRadius = Metric.buttonRadius
        googleButton.layer.masksToBounds = true
        
        appleButton.layer.cornerRadius = Metric.buttonRadius
        appleButton.layer.masksToBounds = true
        
        googleButton.setBackgroundColor(.systemGray5, for: .normal)
        googleButton.setBackgroundColor(.systemGray4, for: .selected)
        googleButton.setBackgroundColor(.systemGray4, for: .disabled)
        
        appleButton.setBackgroundColor(.systemGray5, for: .normal)
        appleButton.setBackgroundColor(.systemGray4, for: .selected)
        appleButton.setBackgroundColor(.systemGray4, for: .disabled)
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
    private func googleButtonTapped() {
        viewModel.performGoogleLogin(on: self)
    }
    
    private func appleButtonTapped() {
        viewModel.performAppleLogin(on: self)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
}
