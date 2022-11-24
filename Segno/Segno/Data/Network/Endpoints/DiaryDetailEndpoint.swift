//
//  DiaryDetailEndpoint.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/23.
//

import Foundation

enum DiaryDetailEndpoint: Endpoint {
    case item(String)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var path: String {
        return "items"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .item(let id):
            return HTTPRequestParameter.queries(["id": id])
        }
    }
}
