//
//  ChangeUserNameUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/30.
//

import RxSwift

protocol ChangeUserNameUseCase {
    func requestChangeNickname(to nickname: String) -> Single<Bool>
}

final class ChangeUserNameUseCaseImpl: ChangeUserNameUseCase {
    let repository: SettingsRepository
    private let disposeBag = DisposeBag()
    
    init(repository: SettingsRepository = SettingsRepositoryImpl()) {
        self.repository = repository
    }
    
    func requestChangeNickname(to nickname: String) -> Single<Bool> {
        return repository.changeNickname(to: nickname)
    }
}
