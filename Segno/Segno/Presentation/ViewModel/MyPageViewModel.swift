//
//  MyPageViewModel.swift
//  Segno
//
//  Created by 이예준 on 2022/11/29.
//

import RxSwift

final class MyPageViewModel {
    private let useCase: UserDetailUseCase
    private let loginUseCase: LoginUseCase
    private var disposeBag = DisposeBag()
    private var userDetailItem = PublishSubject<UserDetailItem>()
    
    lazy var nicknameObservable = userDetailItem.map { $0.nickname }
    lazy var writtenDiaryObservable = userDetailItem.map { $0.diaryCount }
    var failureObservable = Observable<Bool>.empty()
    
    var isLogoutSucceeded = PublishSubject<Bool>()
    
    init(useCase: UserDetailUseCase = UserDetailUseCaseImpl(),
         loginUseCase: LoginUseCase = LoginUseCaseImpl()) {
        self.useCase = useCase
        self.loginUseCase = loginUseCase
    }
    
    func getUserDetail() {
        useCase.getUserDetail()
            .subscribe(onSuccess: { [weak self] userDetail in
                self?.userDetailItem.onNext(userDetail)
            }, onFailure: { [weak self] error in
                print(error.localizedDescription)
                self?.failureObservable = Observable<Bool>.just(false)
            })
            .disposed(by: disposeBag)
    }
    
    func logout(token: String) {
        loginUseCase.sendLogoutRequest(token: token)
            .subscribe(onSuccess: { [weak self] result in
                self?.isLogoutSucceeded.onNext(result)
            }, onFailure: { [weak self] _ in
                self?.isLogoutSucceeded.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
