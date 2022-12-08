//
//  MyPageViewModel.swift
//  Segno
//
//  Created by 이예준 on 2022/11/29.
//

import RxSwift

final class MyPageViewModel {
    let useCase: UserDetailUseCase
    var userDetailItem = PublishSubject<UserDetailItem>()
    lazy var nicknameObservable = userDetailItem.map { $0.nickname }
    lazy var writtenDiaryObservable = userDetailItem.map { $0.diaryCount }
    
    private let disposeBag = DisposeBag()
    
    init(useCase: UserDetailUseCase = UserDetailUseCaseImpl()) {
        self.useCase = useCase
    }
    
    func getUserDetail() {
        useCase.getUserDetail()
            .subscribe(onSuccess: { [weak self] userDetail in
                self?.userDetailItem.onNext(userDetail)
            }, onFailure: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
