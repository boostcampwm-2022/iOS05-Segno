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
    
    private var session: LoginSession?
    weak var delegate: LoginViewControllerDelegate?
    
    private enum Metric {
        static let titleText = "Segno"
        static let subTitleText = "다시 이곳의 추억에서부터"
        static let footerText = "D.S."
        
        static let buttonHeight: CGFloat = 50
        static let footerBottomOffset: CGFloat = -100
        static let footerHeight: CGFloat = 50
        static let inset: CGFloat = 20
        static let subTitleFontSize: CGFloat = 30
        static let subTitleHeight: CGFloat = 50
        static let titleFontSize: CGFloat = 80
        static let titleHeight: CGFloat = 100
        static let titleOffset: CGFloat = 200
    }
    
    // MARK: - View
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Metric.titleText
        label.font = .appFont(.shiningStar, size: Metric.titleFontSize)
        label.textColor = .appColor(.black)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Metric.subTitleText
        label.font = .appFont(.shiningStar, size: Metric.subTitleFontSize)
        label.textColor = .appColor(.grey2)
        return label
    }()
    
    private lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return button
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.text = Metric.footerText
        label.textAlignment = .right
        label.textColor = .appColor(.grey2)
        return label
    }()
    
    private lazy var buttonStackHolder: UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
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
        session = LoginSession(presenter: self)
        bindAppleLoginResult()
        subscribeLoginResult()
    }
    
    // MARK: - Private
    private func bindAppleLoginResult() {
        session?.appleEmail
            .subscribe(onNext: { email in
                self.viewModel.signIn(withApple: email)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupRx() {
        appleButton.rx.controlEvent(.touchDown)
            .withUnretained(self)
            .bind { _ in
                self.appleButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        view.backgroundColor = .appColor(.background)
    }
    
    private func setupLayout() {
        [titleLabel, subTitleLabel, appleButton, footerLabel, buttonStackHolder].forEach {
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
            make.height.equalTo(Metric.footerHeight)
            make.bottom.equalToSuperview().offset(Metric.footerBottomOffset)
        }
        
        buttonStackHolder.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom)
            make.bottom.equalTo(footerLabel.snp.top)
        }
        
        appleButton.snp.makeConstraints { make in
            make.centerY.equalTo(buttonStackHolder.snp.centerY)
            make.height.equalTo(Metric.buttonHeight)
        }
    }
    
    private func subscribeLoginResult() {
        viewModel.isLoginSucceeded
            .subscribe(onNext: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case true:
                        self?.titleLabel.backgroundColor = .blue // 테스트용 색상
                        self?.delegate?.loginDidSucceed()
                    case false:
                        self?.titleLabel.backgroundColor = .orange // 테스트용 색상
                        self?.delegate?.loginDidFail()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public
    private func appleButtonTapped() {
        session?.performAppleLogin()
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
}
