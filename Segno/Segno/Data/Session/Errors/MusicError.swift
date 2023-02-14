//
//  MusicError.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/08.
//

import Foundation

enum MusicError: Error, LocalizedError {
    case notAuthorized
    case failedToCheckAuthorization
    case libraryAccessDenied
    case failedToFetch
    case failedToPlay
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Apple Music을 구독하고 있지 않습니다. 음악을 재생하려면 Apple Music을 구독해야 합니다."
        case .failedToCheckAuthorization:
            return "Apple Music 구독 상태를 불러오는 데 실패했습니다."
        case .libraryAccessDenied:
            return "음악 라이브러리 접근이 거부되었습니다. 설정 - Segno에서 미디어 및 Apple Music 접근 권한을 활성화해주세요."
        case .failedToFetch:
            return "음악 검색 결과를 가져오는 데 실패했습니다."
        case .failedToPlay:
            return "플레이어가 음악을 재생하는 데 실패했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
