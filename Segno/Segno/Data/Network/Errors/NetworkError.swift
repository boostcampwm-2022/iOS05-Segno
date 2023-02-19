//
//  NetworkError.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/14.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case failedToCreateURL
    case failedToCreateRequest
    case failedToGetHTTPResponse
    case failedToGetData
    case invalidNetworkStatusCode(code: Int)
    case unknownNetworkError
    
    var errorDescription: String {
        switch self {
        case .failedToCreateURL:
            return "URL 생성에 실패했습니다."
        case .failedToCreateRequest:
            return "URL 요청 생성에 실패했습니다."
        case .failedToGetHTTPResponse:
            return "HTTP 응답을 받는 데 실패했습니다."
        case .failedToGetData:
            return "데이터를 불러오는 데 실패했습니다."
        case .invalidNetworkStatusCode(let code):
            return "서버에서 오류를 전송했습니다 (오류 코드: \(code))."
        case .unknownNetworkError:
            return "알 수 없는 네트워크 오류입니다."
        }
    }
}
