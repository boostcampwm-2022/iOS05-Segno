//
//  MusicError.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/08.
//

import Foundation

enum MusicError: Error, LocalizedError {
    case libraryAccessDenied
    case failedToFetch
    case failedToPlay
    
    var errorDescription: String? {
        switch self {
        case .libraryAccessDenied:
            return "음악 라이브러리 접근이 거부되었습니다. 설정 - Segno에서 미디어 및 Apple Music 접근 권한을 활성화해주세요."
        case .failedToFetch:
            return "음악 검색 결과를 가져오는 데 실패했습니다."
        case .failedToPlay:
            return "플레이어가 음악을 재생하는 데 실패했습니다."
        }
    }
}
