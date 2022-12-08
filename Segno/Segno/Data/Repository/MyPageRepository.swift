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
    private let localUtilityRepository = LocalUtilityRepositoryImpl()
    
    func getUserDetail() -> Single<UserDetailDTO> {
        let token = localUtilityRepository.getToken()
        let endpoint = UserDetailEndpoint.item(token)

        return NetworkManager.shared.call(endpoint)
            .map {
                let userDetailDTO = try JSONDecoder().decode(UserDetailDTO.self, from: $0)
                return userDetailDTO
            }
    }
}
