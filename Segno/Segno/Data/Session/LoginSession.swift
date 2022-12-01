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

final class LoginSession: NSObject {
    private let presenter: LoginViewController
    var authorizationController: ASAuthorizationController?
    var appleEmail = PublishSubject<String>()
    
    init(presenter: LoginViewController) {
        self.presenter = presenter
    }
    
    func performAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController?.delegate = self
        authorizationController?.presentationContextProvider = presenter
        authorizationController?.performRequests()
    }
    
    func performGoogleLogin() -> Observable<String> {
        return Observable.create() { emitter in
            let signInConfig = GIDConfiguration.init(clientID: "880830660858-2niv4cb94c63omf91uej9f23o7j15n8r.apps.googleusercontent.com")
            
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self.presenter) { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                
                if let userId = user.userID,                  // For client-side use only!
                   let idToken = user.authentication.idToken, // Safe to send to the server
                   let fullName = user.profile?.name,
                   let email = user.profile?.email {
                    debugPrint("Token : \(idToken)")
                    debugPrint("User ID : \(userId)")
                    debugPrint("User Email : \(email)")
                    debugPrint("User Name : \((fullName))")
                    
                    emitter.onNext(email)
                    emitter.onCompleted()
                } else {
                    debugPrint("Error : User Data Not Found")
                    emitter.onError(LoginError.userDataNotFound)
                }
            }
            return Disposables.create()
        }
    }
}

extension LoginSession: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let auth = authorization.credential as? ASAuthorizationAppleIDCredential,
              let data = auth.identityToken,
              let email = parseEmailFromJWT(data) else {
            // TODO: 중간에 데이터를 가져오는 과정 하나라도 실패했을 때 에러 처리
            debugPrint("데이터를 변환하는 데 실패")
            return
        }
        
        appleEmail.onNext(email)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: 아예 인증이 안 됐을 때 에러 처리
        debugPrint("인증 실패")
    }
}

extension LoginSession {
    // MARK: - jwt 해석 메서드
    func parseEmailFromJWT(_ jwtData: Data?) -> String? {
        var email: String?
        guard let jwtData = jwtData,
              let jwt = String(data: jwtData, encoding: .ascii) else { return nil }
        
        // parse body from jwt
        let jwtElement = jwt.split(separator: ".").map {
            String($0)
        }.compactMap {
            Data(base64Encoded: $0)
        }
        
        guard jwtElement.count != 0 else { return nil }
        
        let data = parseBodyFromJWTData(jwtElement)
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
           let emailFromJson = json["email"] as? String {
            email = emailFromJson
        }
        
        return email
    }
    
    private func parseBodyFromJWTData(_ jwtData: [Data]) -> Data {
        if jwtData.count > 1 {
            return jwtData[1]
        } else {
            return jwtData[0]
        }
    }
}
