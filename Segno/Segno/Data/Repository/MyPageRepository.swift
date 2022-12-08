//
//  MyPageRepository.swift
//  Segno
//
//  Created by 이예준 on 2022/11/30.
//

import Foundation

import RxSwift

protocol MyPageRepository {
    func getUserDetail() -> Single<UserDetailDTO>
}

final class MyPageRepositoryImpl: MyPageRepository {
    func getUserDetail() -> Single<UserDetailDTO> {
        // TODO: Keychain으로부터 토큰 가져오기
        let token = "A1lmMjb2pgNWg6ZzAaPYgMcqRv/8BOyO4U/ui6i/Ic4="
        let endpoint = UserDetailEndpoint.item(token)

        return NetworkManager.shared.call(endpoint)
            .map {
                let userDetailDTO = try JSONDecoder().decode(UserDetailDTO.self, from: $0)
                return userDetailDTO
            }
    }
}
