//
//  SettingsEndpoint.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/01.
//

import Foundation

enum ChangeNicknameEndpoint: Endpoint {
    case item(String, String)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .PATCH
    }
    
    var path: String {
        return "user"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .item(let token, let nickName):
            return HTTPRequestParameter.body(["token": token, "nickName": nickName])
        }
    }
}
