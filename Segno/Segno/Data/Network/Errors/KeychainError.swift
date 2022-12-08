//
//  KeychainError.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/15.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case duplicatedKey
    case unexpectedPasswordData
    case unexpectedToken
    case unhandledError(status: OSStatus)
}
