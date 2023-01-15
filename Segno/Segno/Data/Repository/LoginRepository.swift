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
    func sendLogoutRequest()
    func sendResignRequest(token: String) -> Completable
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
    
    func sendLogoutRequest() {
        // TODO: Logout
    }
    
    func sendResignRequest(token: String) -> Completable {
        let endpoint = ResignEndpoint.resign(token)
        return NetworkManager.shared.call(endpoint)
            .asCompletable()
    }
}
