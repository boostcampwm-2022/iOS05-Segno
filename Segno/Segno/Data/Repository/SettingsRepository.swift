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
    func changeNickname(to nickname: String) -> Single<Bool> {
        // TODO: Keychain으로부터 토큰 가져오기
        let token = "/43JoWf24Y7SS8yJj3oIPqIFGZRD3P7u9kUZVwkMwug="
        let endpoint = ChangeNicknameEndpoint.item(token: token, nickname: nickname)
        return NetworkManager.shared.call(endpoint)
            .map { _ in
                return true
            }
    }
}
