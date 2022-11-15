//
//  LocalUtilityRepository.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/14.
//

import Foundation
import RxSwift

protocol LocalUtilityRepository {
    func createToken(key: Any, token: Any) -> Single<Bool>
    func getToken(key: Any) -> Single<Any>
}

final class LocalUtilityRepositoryImpl: LocalUtilityRepository {
    func createToken(key: Any, token: Any) -> Single<Bool> {
        return Single.create { single in
            let token = (token as AnyObject).data(using: String.Encoding.utf8.rawValue)!
            let addQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: token
            ]
            
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            if status == errSecSuccess {
                single(.success(true))
            }
            else if status == errSecDuplicateItem {
                single(.failure(KeychainError.duplicatedKey))
            }
            else {
                single(.failure(KeychainError.unhandledError(status: status)))
            }
            return Disposables.create()
        }
    }
    
    func getToken(key: Any) -> Single<Any> {
        return Single.create { single in
            let getQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnAttributes as String: true,
                kSecReturnData as String: true
            ]
            var item: CFTypeRef?
            let result = SecItemCopyMatching(getQuery as CFDictionary, &item)
            if result == errSecSuccess {
                if let existingItem = item as? [String: Any],
                   let data = existingItem[kSecValueData as String] as? Data,
                   let token = String(data: data, encoding: .utf8) {
                    single(.success(token))
                } else {
                    single(.failure(KeychainError.unexpectedToken))
                }
            } else {
                single(.failure(KeychainError.unexpectedToken))
            }
            return Disposables.create()
        }
    }
    
    func updateToken(key: Any, token: Any) -> Bool {
        let prevQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let token = (token as AnyObject).data(using: String.Encoding.utf8.rawValue)!
        let updateQuery: [String: Any] = [
            kSecValueData as String: token as Any
        ]
        
        let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
}
