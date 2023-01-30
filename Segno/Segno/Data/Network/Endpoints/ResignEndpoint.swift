//
//  ResignEndpoint.swift
//  Segno
//
//  Created by Gordon Choi on 2023/01/16.
//

import Foundation

enum ResignEndpoint: Endpoint {
    case resign(String)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)?
            .appendingPathComponent("auth")
    }
    
    var httpMethod: HTTPMethod {
        return .POST
    }
    
    var path: String {
        return "withdrawal"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .resign(let token):
            return HTTPRequestParameter.body(["token": token])
        }
    }
}
