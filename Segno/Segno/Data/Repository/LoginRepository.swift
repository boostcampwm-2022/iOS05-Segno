//
//  LoginRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/16.
//

import Foundation

import RxSwift

protocol LoginRepository {
    func sendLoginRequest(withApple email: String) -> Single<UserLoginDTO>
    func sendLogoutRequest(token: String) -> Single<Bool>
}

final class LoginRepositoryImpl: LoginRepository {
    func sendLoginRequest(withApple email: String) -> Single<UserLoginDTO> {
        let endpoint = LoginEndpoint.apple(email)
        return NetworkManager.shared.call(endpoint)
            .map {
                let userLoginDTO = try JSONDecoder().decode(UserLoginDTO.self, from: $0)
                return userLoginDTO
            }
    }
    
    func sendLogoutRequest(token: String) -> Single<Bool> {
        let endpoint = LogoutEndpoint.item(token)
        return NetworkManager.shared.call(endpoint)
            .map { _ in
                return true
            }
    }
}
