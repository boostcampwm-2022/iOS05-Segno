//
//  DiaryListItemEndpoint.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/15.
//

import Foundation

// TODO: 서버 구현이 완료된 후 그에 맞게 바뀔 예정입니다.
enum DiaryListItemEndpoint: Endpoint {
    case item
    
    var baseURL: URL? {
        return URL(string: "https://baero.me")
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var path: String {
        return "items"
    }
    
    var parameters: HTTPRequestParameter? {
        return nil
    }
}
