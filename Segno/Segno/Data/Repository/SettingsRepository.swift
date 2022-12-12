//
//  SettingsRepository.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/30.
//

import RxSwift

protocol SettingsRepository {
    func changeNickname(to nickname: String) -> Single<Bool>
}

final class SettingsRepositoryImpl: SettingsRepository {
    private let localUtilityRepository = LocalUtilityManagerImpl()
    
    func changeNickname(to nickname: String) -> Single<Bool> {
        let token = localUtilityRepository.getToken()
        let endpoint = ChangeNicknameEndpoint.item(token: token, nickname: nickname)
        return NetworkManager.shared.call(endpoint)
            .map { _ in
                return true
            }
    }
}
