//
//  ShazamError.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/07.
//

import Foundation

enum ShazamError: Error, LocalizedError {
    case recordDenied
    case unknown
    case matchFailed
    
    var errorDescription: String {
        switch self {
        case .recordDenied:
            return "Record permission is denied. Please enable it in Settings."
        case .matchFailed:
            return "No song found or internet connection is bad."
        case .unknown:
            return "Unknown error occured."
        }
    }
}
