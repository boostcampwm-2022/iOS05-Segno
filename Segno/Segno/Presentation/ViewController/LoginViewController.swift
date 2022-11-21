//
//  ViewController.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/09.
//

import AuthenticationServices
import UIKit

import GoogleSignIn
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
        
        bindAppleCredential()
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
        let signInConfig = GIDConfiguration.init(clientID: "880830660858-2niv4cb94c63omf91uej9f23o7j15n8r.apps.googleusercontent.com")

        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            if let userId = user.userID,                  // For client-side use only!
               let idToken = user.authentication.idToken, // Safe to send to the server
               let fullName = user.profile?.name,
               let givenName = user.profile?.givenName,
               let familyName = user.profile?.familyName,
               let email = user.profile?.email {
                print("Token : \(idToken)")
                print("User ID : \(userId)")
                print("User Email : \(email)")
                print("User Name : \((fullName))")
                
                self.viewModel.signIn(withGoogle: email)
            } else {
                print("Error : User Data Not Found")
            }
            
            // TODO: ViewModel로 적절한 데이터(authentication / idToken 등) 전송
//            user.authentication.do { [self] authentication, error in
//                guard error == nil else { print(error); return }
//                guard let authentication = authentication else { return }
//
//                let idToken = authentication.idToken
//                print(userId)
//                print(idToken)
//            }
        }
    }
    
    private func appleButtonTapped() {
        LoginSession.shared.setPresentationContextProvider(self)
        LoginSession.shared.performAppleLogin()
    }
    
    private func bindAppleCredential() {
        let appleCredentialResult = LoginSession.shared.appleCredential
        
        appleCredentialResult
            .subscribe(onNext: { result in
                switch result {
                case .success(let credential):
                    print(credential.fullName?.givenName ?? "NO NAME")
                    print(credential.email ?? "NO EMAIL")
                    print(credential.user)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}

//extension LoginViewController: ASAuthorizationControllerDelegate {
//    // Apple ID 연동 성공 시
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        // TODO: viewModel로 authoriztion 전송하기
//        viewModel.signIn(withApple: authorization)
//        // TODO: 코디네이터에게 알리기
//
//        // 아래는 테스트용 출력
//        #if DEBUG
//        switch authorization.credential {
//        // Apple ID
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//            // 계정 정보 가져오기
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            print("User ID : \(userIdentifier)")
//            print("User Email : \(email ?? "")")
//            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
//
//        default:
//            break
//        }
//        #endif
//    }
//
//    // Apple ID 연동 실패 시
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        // Handle error.
//        print("didCompleteWithError")
//    }
//}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
