//
//  ChangeNicknameUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/30.
//

import RxSwift

protocol ChangeNicknameUseCase {
    func requestChangeNickname(to nickname: String) -> Single<Bool>
}

final class ChangeNicknameUseCaseImpl: ChangeNicknameUseCase {
    let repository: SettingsRepository
    private var disposeBag = DisposeBag()
    
    init(repository: SettingsRepository = SettingsRepositoryImpl()) {
        self.repository = repository
    }
    
    func requestChangeNickname(to nickname: String) -> Single<Bool> {
        return repository.changeNickname(to: nickname)
    }
}
