//
//  ImageEndpoint.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/27.
//

import Foundation

enum ImageEndpoint: Endpoint {
    case item(Data)
    
    var baseURL: URL? {
        return URL(string: BaseURL.urlString)
    }
    
    var httpMethod: HTTPMethod {
        return .POST
    }
    
    var path: String {
        return "image"
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .item(let image):
            return HTTPRequestParameter.data(image)
        }
    }
}
