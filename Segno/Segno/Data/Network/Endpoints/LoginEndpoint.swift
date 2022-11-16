//
//  LoginEndpoint.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/16.
//

import Foundation

enum LoginEndpoint: Endpoint {
    case apple(String)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .POST
    }
    
    var path: String {
        return "login"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .apple(let email):
            return HTTPRequestParameter.body(["email": email, "oauthType": "apple"])
        }
    }
}
