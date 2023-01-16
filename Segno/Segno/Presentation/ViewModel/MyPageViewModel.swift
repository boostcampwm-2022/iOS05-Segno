//
//  MyPageViewModel.swift
//  Segno
//
//  Created by 이예준 on 2022/11/29.
//

import RxSwift

final class MyPageViewModel {
    private let useCase: UserDetailUseCase
    private var disposeBag = DisposeBag()
    private var userDetailItem = PublishSubject<UserDetailItem>()
    
    lazy var nicknameObservable = userDetailItem.map { $0.nickname }
    lazy var writtenDiaryObservable = userDetailItem.map { $0.diaryCount }
    var failureObservable = Observable<Bool>.empty()
    
    init(useCase: UserDetailUseCase = UserDetailUseCaseImpl()) {
        self.useCase = useCase
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
}
