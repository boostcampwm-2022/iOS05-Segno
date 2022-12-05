//
//  DiaryDeleteEndpoint.swift
//  Segno
//
//  Created by TaehoYoo on 2022/12/05.
//

import Foundation

enum DiaryDeleteEndpoint: Endpoint {
    case item(token: String, diaryId: String)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .DELETE
    }
    
    var path: String {
        return "diary"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .item(let token, let diaryId):
            return HTTPRequestParameter.body(["token": token, "diaryId": diaryId])
        }
    }
}
