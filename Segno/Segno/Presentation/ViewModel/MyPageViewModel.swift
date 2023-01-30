//
//  MyPageViewModel.swift
//  Segno
//
//  Created by 이예준 on 2022/11/29.
//

import RxSwift

final class MyPageViewModel {
    private let userDetailUseCase: UserDetailUseCase
    private let resignUseCase: ResignUseCase
    private let loginUseCase: LoginUseCase
    private var disposeBag = DisposeBag()
    private var userDetailItem = PublishSubject<UserDetailItem>()
    
    lazy var nicknameObservable = userDetailItem.map { $0.nickname }
    lazy var writtenDiaryObservable = userDetailItem.map { $0.diaryCount }
    var failureObservable = Observable<Bool>.empty()
    
    init(userDetailUseCase: UserDetailUseCase = UserDetailUseCaseImpl(),
         resignUseCase: ResignUseCase = ResignUseCaseImpl()
         loginUseCase: LoginUseCase = LoginUseCaseImpl()) {
        self.userDetailUseCase = userDetailUseCase
        self.resignUseCase = resignUseCase
        self.loginUseCase = loginUseCase
    }
    
    func getUserDetail() {
        userDetailUseCase.getUserDetail()
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
    
    func resign() {
        resignUseCase.sendResignRequest()
            .subscribe(onCompleted: {
                // 탈퇴시 수행할 액션?
            }, onError: { [weak self] error in
                // 탈퇴 과정에서 에러가 났을 경우?
                debugPrint(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
