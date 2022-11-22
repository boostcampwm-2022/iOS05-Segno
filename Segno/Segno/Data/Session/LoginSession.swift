//
//  LoginSession.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/21.
//

import AuthenticationServices
import Foundation

import GoogleSignIn
import RxSwift

typealias AppleLoginResult = Result<ASAuthorizationAppleIDCredential, Error>
typealias GoogleLoginResult = Result<String, Error>

final class LoginSession: NSObject {
    static let shared = LoginSession()
    
    var authorizationController: ASAuthorizationController?
    var appleCredentialResult = PublishSubject<AppleLoginResult>()
    var googleLoginResult = PublishSubject<GoogleLoginResult>()
    
    private override init() { }
    
    func performAppleLogin(on presenter: ASAuthorizationControllerPresentationContextProviding) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController?.delegate = self
        authorizationController?.presentationContextProvider = presenter
        authorizationController?.performRequests()
    }
    
    func performGoogleLogin(_ presenter: UIViewController) {
        let signInConfig = GIDConfiguration.init(clientID: "880830660858-2niv4cb94c63omf91uej9f23o7j15n8r.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: presenter) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            if let userId = user.userID,                  // For client-side use only!
               let idToken = user.authentication.idToken, // Safe to send to the server
               let fullName = user.profile?.name,
               let givenName = user.profile?.givenName,
               let familyName = user.profile?.familyName,
               let email = user.profile?.email {
                print("Token : \(idToken)")
                print("User ID : \(userId)")
                print("User Email : \(email)")
                print("User Name : \((fullName))")
                self.googleLoginResult.onNext(.success(email))
            } else {
                print("Error : User Data Not Found")
                // TODO: 커스텀 에러 타입 적용
            }
        }
    }
}

extension LoginSession: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let auth = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        appleCredentialResult.onNext(.success(auth))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        appleCredentialResult.onNext(.failure(error))
    }
}
