//
//  DiaryListItemEndpoint.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/15.
//

import Foundation

enum DiaryListItemEndpoint: Endpoint {
    case item
    
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
        return nil
    }
}
