//
//  DiaryUpdateEndpoint.swift
//  Segno
//
//  Created by 이예준 on 2022/12/13.
//

import Foundation

enum DiaryUpdateEndpoint: Endpoint {
    case item(diary: DiaryDetail)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .PATCH
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
