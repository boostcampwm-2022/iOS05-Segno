//
//  DiaryPostEndpoint.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/27.
//

import Foundation

enum DiaryPostEndpoint: Endpoint {
    case item(DiaryDetail)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var path: String {
        return "diary"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .item(let diary):
            return HTTPRequestParameter.body(diary)
        }
    }
}
