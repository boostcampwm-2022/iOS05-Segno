//
//  LogoutEndpoint.swift
//  Segno
//
//  Created by 이예준 on 2023/01/08.
//

import Foundation

enum LogoutEndpoint: Endpoint {
    case item(String)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)?
            .appendingPathComponent("auth")
    }
    
    var httpMethod: HTTPMethod {
        return .POST
    }
    
    var path: String {
        return "logout"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .item(let token):
            return HTTPRequestParameter.body(["token": token])
        }
    }
}
