//
//  UserDetailUseCase.swift
//  Segno
//
//  Created by 이예준 on 2022/11/30.
//

import RxSwift

protocol UserDetailUseCase {
    func getUserDetail() -> Single<UserDetailItem>
}

final class UserDetailUseCaseImpl: UserDetailUseCase {
    let repository: MyPageRepository
    private let disposeBag = DisposeBag()
    
    init(repository: MyPageRepository = MyPageRepositoryImpl()) {
        self.repository = repository
    }
    
    func getUserDetail() -> Single<UserDetailItem> {
        return repository.getUserDetail().map {
            UserDetailItem(identifier: $0.identifier, nickname: $0.nickname, writtenDiary: $0.writtenDiary)
        }
    }
}
