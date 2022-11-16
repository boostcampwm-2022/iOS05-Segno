//
//  LoginRepository.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/16.
//

import RxSwift

protocol LoginRepository {
    func sendOAuthRequest()
    func sendLoginRequest()
    func sendLogoutRequest()
}

final class LoginRepositoryImpl: LoginRepository {
    func sendOAuthRequest() {
        
    }
    
    func sendLoginRequest() {
        
    }
    
    func sendLogoutRequest() {
        
    }
}
