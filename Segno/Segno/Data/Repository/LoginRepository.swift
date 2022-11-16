//
//  LoginRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/16.
//

import RxSwift

protocol LoginRepository {
    func sendLoginRequest(id: String)
    func sendLogoutRequest()
}

final class LoginRepositoryImpl: LoginRepository {
    func sendLoginRequest(id: String) {
        
    }
    
    func sendLogoutRequest() {
        
    }
}
