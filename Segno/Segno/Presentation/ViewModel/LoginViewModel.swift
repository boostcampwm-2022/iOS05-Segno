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
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func signIn(withApple authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let email = appleIDCredential.email ?? "thefirate@gmail.com"
            
            useCase.sendLoginRequest(email: email)
                .subscribe(onSuccess: { [weak self] _ in
                    self?.isLoginSucceeded.onNext(true)
                }, onFailure: { [weak self] _ in
                    self?.isLoginSucceeded.onNext(false)
                })
                .disposed(by: disposeBag)
        default:
            return
        }
    }
    
    // TODO: 서버 이슈 해결된 뒤, 구글 로그인과 애플 로그인 함수 합치기
    func signIn(withGoogle email: String) {
        useCase.sendLoginRequest(email: email)
            .subscribe(onSuccess: { [weak self] _ in
                self?.isLoginSucceeded.onNext(true)
            }, onFailure: { [weak self] _ in
                self?.isLoginSucceeded.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
