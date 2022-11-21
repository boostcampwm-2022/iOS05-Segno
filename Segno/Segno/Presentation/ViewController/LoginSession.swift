//
//  LoginSession.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/21.
//

import AuthenticationServices
import Foundation

import RxSwift

final class LoginSession: NSObject {
    static let shared = LoginSession()
    
    var authorizationController: ASAuthorizationController?
    var appleCredential = PublishSubject<ASAuthorizationAppleIDCredential>()
    
    private override init() { }
    
    func setPresentationContextProvider(_ object: ASAuthorizationControllerPresentationContextProviding) {
        authorizationController?.presentationContextProvider = object
    }
    
    func performAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController?.delegate = self
        authorizationController?.performRequests()
    }
}

extension LoginSession: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let auth = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        appleCredential.onNext(auth)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        appleCredential.onError(error)
    }
}
