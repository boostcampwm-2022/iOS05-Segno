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
import AuthenticationServices

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
    private func appleButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // TODO: viewModel로 authoriztion 전송하기
//        viewModel.signIn(withApple: authorization)
        // TODO: 코디네이터에게 알리기
        
        // 아래는 테스트용 출력
        #if DEBUG
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")

        default:
            break
        }
        #endif
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("didCompleteWithError")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
