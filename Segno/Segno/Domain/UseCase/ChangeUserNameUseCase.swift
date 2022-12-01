//
//  ChangeUserNameUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/30.
//

import RxSwift

protocol ChangeUserNameUseCase {
    func requestChangeNickname(to nickname: String) -> Bool
}

final class ChangeUserNameUseCaseImpl: ChangeUserNameUseCase {
    let repository: SettingsRepository
    private let disposeBag = DisposeBag()
    
    init(repository: SettingsRepository = SettingsRepositoryImpl()) {
        self.repository = repository
    }
    
    func requestChangeNickname(to nickname: String) -> Bool {
        // 임시 처리입니다.
        debugPrint("SettingsUseCase - requestChangeNickname : \(nickname)으로 변경")
        return true
    }
}
