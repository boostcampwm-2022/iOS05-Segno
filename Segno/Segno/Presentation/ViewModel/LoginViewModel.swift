//
//  LoginViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/17.
//

import RxSwift

final class LoginViewModel {
    private let useCase: LoginUseCase
    private var disposeBag = DisposeBag()
    
    var isLoginSucceeded = PublishSubject<Bool>()
    
    init(useCase: LoginUseCase = LoginUseCaseImpl()) {
        self.useCase = useCase
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
}
