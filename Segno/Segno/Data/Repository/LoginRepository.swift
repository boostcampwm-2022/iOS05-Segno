//
//  LoginRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/16.
//

import Foundation
import RxSwift

protocol LoginRepository {
    func sendLoginRequest(email: String) -> Single<TokenDTO>
    func sendLogoutRequest()
}

final class LoginRepositoryImpl: LoginRepository {
    func sendLoginRequest(email: String) -> Single<TokenDTO> {
        let endpoint = LoginEndpoint.apple(email)
        return NetworkManager.shared.call(endpoint)
            .map {
                let tokenDTO = try JSONDecoder().decode(TokenDTO.self, from: $0)
                return tokenDTO
            }
    }
    
    func sendLogoutRequest() {
        
    }
}
