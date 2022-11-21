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
        
        bindAppleCredential()
    }
    
    func setPresentationContextProvider(_ object: ASAuthorizationControllerPresentationContextProviding) {
        session.setPresentationContextProvider(object)
    }
    
    func performAppleLogin() {
        session.performAppleLogin()
    }
    
    private func bindAppleCredential() {
        session.appleCredentialResult
            .subscribe(onNext: { result in
                switch result {
                case .success(let credential):
                    print(credential.fullName?.givenName ?? "NO NAME")
                    print(credential.email ?? "NO EMAIL")
                    print(credential.user)
                    
                    guard let email = self.parseEmailFromJWT(credential.identityToken) else {
                        return
                    }
                    
                    self.signIn(withApple: email)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func signIn(withApple email: String) {
        useCase.sendLoginRequest(withApple: email)
                .subscribe(onSuccess: { [weak self] _ in
                    self?.isLoginSucceeded.onNext(true)
                }, onFailure: { [weak self] _ in
                    self?.isLoginSucceeded.onNext(false)
                })
                .disposed(by: disposeBag)
    }
    
    // TODO: 서버 이슈 해결된 뒤, 구글 로그인과 애플 로그인 함수 합치기
    func signIn(withGoogle email: String) {
        useCase.sendLoginRequest(withGoogle: email)
            .subscribe(onSuccess: { [weak self] _ in
                self?.isLoginSucceeded.onNext(true)
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
