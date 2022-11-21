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
