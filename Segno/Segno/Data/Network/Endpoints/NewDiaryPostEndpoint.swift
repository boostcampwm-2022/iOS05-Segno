//
//  NewDiaryPostEndpoint.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/08.
//

import Foundation

enum NewDiaryPostEndpoint: Endpoint {
    case item(NewDiaryDetail)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .POST
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
