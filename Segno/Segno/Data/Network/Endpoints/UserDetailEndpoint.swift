//
//  UserDetailEndpoint.swift
//  Segno
//
//  Created by 이예준 on 2022/11/30.
//

import Foundation

enum UserDetailEndpoint: Endpoint {
    case item
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var path: String {
        // TODO: 서버에 맞춰서 path 조정
        return ""
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .item:
            return HTTPRequestParameter.queries([:]) // TODO: queries로 무언가 들어가야함
        }
    }
}
