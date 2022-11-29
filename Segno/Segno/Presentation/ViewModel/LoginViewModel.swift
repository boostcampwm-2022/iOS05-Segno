//
//  LoginViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/17.
//

import AuthenticationServices

import RxSwift

final class LoginViewModel {
    let useCase: LoginUseCase
    let session = LoginSession.shared
    private let disposeBag = DisposeBag()
    
    var isLoginSucceeded = PublishSubject<Bool>()
    
    init(useCase: LoginUseCase = LoginUseCaseImpl()) {
        self.useCase = useCase
        
        bindAppleLoginResult()
    }
    
    private func bindAppleLoginResult() {
        session.appleCredentialResult
            .subscribe(onNext: { result in
                switch result {
                case .success(let credential):
                    guard let email = self.parseEmailFromJWT(credential.identityToken) else { return }

                    self.signIn(withApple: email)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func performAppleLogin(on presenter: ASAuthorizationControllerPresentationContextProviding) {
        session.performAppleLogin(on: presenter)
    }
    
    func performGoogleLogin(on presenter: UIViewController) {
        session.performGoogleLogin(presenter)
            .subscribe(onNext: { email in
                self.signIn(withGoogle: email)
            })
            .disposed(by: disposeBag)
    }
    
    func signIn(withApple email: String) {
        useCase.sendLoginRequest(withApple: email)
                .subscribe(onSuccess: { [weak self] result in
                    self?.isLoginSucceeded.onNext(result)
                }, onFailure: { [weak self] _ in
                    self?.isLoginSucceeded.onNext(false)
                })
                .disposed(by: disposeBag)
    }
    
    func signIn(withGoogle email: String) {
        useCase.sendLoginRequest(withGoogle: email)
            .subscribe(onSuccess: { [weak self] result in
                self?.isLoginSucceeded.onNext(result)
            }, onFailure: { [weak self] _ in
                self?.isLoginSucceeded.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel {
    // MARK: - jwt 해석 메서드
    func parseEmailFromJWT(_ jwtData: Data?) -> String? {
        var email: String?
        guard let jwtData = jwtData,
              let jwt = String(data: jwtData, encoding: .ascii) else { return nil }
        
        // parse body from jwt
        let jwtElement = jwt.split(separator: ".").map {
            String($0)
        }.compactMap {
            Data(base64Encoded: $0)
        }
        
        guard jwtElement.count != 0 else { return nil }
        
        let data = parseBodyFromJWTData(jwtElement)
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
           let emailFromJson = json["email"] as? String {
            email = emailFromJson
        }
        
        return email
    }
    
    private func parseBodyFromJWTData(_ jwtData: [Data]) -> Data {
        if jwtData.count > 1 {
            return jwtData[1]
        } else {
            return jwtData[0]
        }
    }
}
