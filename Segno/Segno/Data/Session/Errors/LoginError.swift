//
//  LoginError.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/28.
//

import Foundation

enum LoginError: Error, LocalizedError {
    case userDataNotFound
    case failedToDecodeUserInfo
    case failedToCompleteLogin
}
