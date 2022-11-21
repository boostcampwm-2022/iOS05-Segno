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
    private let disposeBag = DisposeBag()
    var isLoginSucceeded = PublishSubject<Bool>()
    
    init(useCase: LoginUseCase = LoginUseCaseImpl()) {
        self.useCase = useCase
    }
    
    func signIn(withApple authorization: ASAuthorization) {
//        return Single.create { single in
//            switch authorization.credential {
//            case let appleIDCredential as ASAuthorizationAppleIDCredential:
//                let userIdentifier = appleIDCredential.user
//                guard let fullName = appleIDCredential.fullName,
//                      let email = appleIDCredential.email else {
//                    single(.success(false))
//                    return Disposables.create()
//                }
//                self.useCase.sendLoginRequest(email: email)
//                    .subscribe(onSuccess: { _ in
//                        single(.success(true))
//                    }, onFailure: { _ in
//                        single(.success(false))
//                    })
//                    .disposed(by: self.disposeBag)
//            default:
//                single(.success(false))
//                break
//            }
//            return Disposables.create()
//        }
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            let userIdentifier = appleIDCredential.user // 애플에서 준 토큰
//            guard let fullName = appleIDCredential.fullName,
//                  let email = appleIDCredential.email else {
//                return
//            }
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
