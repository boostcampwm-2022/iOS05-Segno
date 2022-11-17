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
    
    init(useCase: LoginUseCase = LoginUseCaseImpl()) {
        self.useCase = useCase
    }
    
    func signIn(withApple authorization: ASAuthorization) -> Single<Bool> {
        return Single.create { single in
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let userIdentifier = appleIDCredential.user
                guard let fullName = appleIDCredential.fullName,
                      let email = appleIDCredential.email else {
                    single(.success(false))
                    return Disposables.create()
                }
                self.useCase.sendLoginRequest(email: email)
                    .subscribe(onSuccess: { _ in
                        single(.success(true))
                    }, onFailure: { _ in
                        single(.success(false))
                    })
                    .disposed(by: self.disposeBag)
            default:
                single(.success(false))
                break
            }
            return Disposables.create()
        }
    }
}
