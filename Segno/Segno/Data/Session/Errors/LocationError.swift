//
//  LocationError.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/12.
//

import Foundation

enum LocationError: Error, LocalizedError {
    case denied
    case restricted
    case unknown
    
    var errorDescription: String {
        switch self {
        case .denied:
            return "현재 위치 정보를 받아올 수 없습니다. 설정에서 위치 정보를 받아올 수 있도록 설정해주세요."
        case .restricted:
            return "기기에서 위치 정보를 받아올 수 없습니다. 설정 - 개인정보 보호 및 보안 - 위치 서비스에서 위치 정보를 받아올 수 있도록 설정해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
