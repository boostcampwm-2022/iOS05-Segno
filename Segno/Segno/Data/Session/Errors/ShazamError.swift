//
//  ShazamError.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/07.
//

import Foundation

enum ShazamError: Error, LocalizedError {
    case recordDenied
    case matchFailed
    case unknown
    
    var errorDescription: String {
        switch self {
        case .recordDenied:
            return "마이크 사용 권한이 없습니다. 설정에서 마이크 사용 권한을 활성화해 주세요."
        case .matchFailed:
            return "노래를 찾지 못했거나, 인터넷 연결 상태가 좋지 않습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
