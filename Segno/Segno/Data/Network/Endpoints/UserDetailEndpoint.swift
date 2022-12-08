//
//  UserDetailEndpoint.swift
//  Segno
//
//  Created by 이예준 on 2022/11/30.
//

import Foundation

enum UserDetailEndpoint: Endpoint {
    case item(String)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .POST
    }
    
    var path: String {
        return "user"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .item(let token):
            return HTTPRequestParameter.body(["token": token])
        }
    }
}
