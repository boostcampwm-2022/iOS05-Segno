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
//    func getToken(key: Any) -> Single<Any>?
}

final class LocalUtilityRepositoryImpl: LocalUtilityRepository {
    func createToken(key: Any, token: Any) -> Single<Bool> {
        return Single<Bool>.create { single in
            let addQuery: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: (token as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
            ]
            let result: Bool = {
                let status = SecItemAdd(addQuery as CFDictionary, nil)
                if status == errSecSuccess { return true }
                return false
            }()
            
            single(.success(result))
            return Disposables.create()
        }
    }
}
