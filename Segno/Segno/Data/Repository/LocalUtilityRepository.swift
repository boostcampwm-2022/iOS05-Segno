//
//  LocalUtilityRepository.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/14.
//

import Foundation

protocol LocalUtilityRepository {
    func createToken(token: String) -> Bool
    func getToken() -> String
    func updateToken(token: String) -> Bool
    func deleteToken() -> Bool
    func setUserDefaults(_ value: Any, forKey defaultsKey: UserDefaultsKey)
    func getUserDefaultsObject(forKey defaultsKey: UserDefaultsKey) -> Any?
}

final class LocalUtilityRepositoryImpl: LocalUtilityRepository {
    private let keyName: String = "userToken"
    
    func createToken(token: String) -> Bool {
        let addQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keyName,
            kSecValueData: (token as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
        ]
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        if status == errSecSuccess { return true }
        else if status == errSecDuplicateItem {
            print(KeychainError.duplicatedKey)
            return updateToken(token: token)
        }
        
        print(KeychainError.unhandledError(status: status))
        return false
    }
    
    func getToken() -> String {
        let getQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keyName,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        let result = SecItemCopyMatching(getQuery as CFDictionary, &item)
        if result == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let token = String(data: data, encoding: .utf8) {
                return token
            }
        }
        
        print(KeychainError.unexpectedToken)
        return ""
    }
    
    func updateToken(token: String) -> Bool {
        let prevQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keyName
        ]
        let updateQuery: [CFString: Any] = [ kSecValueData: (token as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any ]
        
        let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
        if status == errSecSuccess { return true }
        
        print(KeychainError.unhandledError(status: status))
        return false
    }
    
    func deleteToken() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: keyName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess { return true }
        
        print(KeychainError.unhandledError(status: status))
        return false
    }
    
    func setUserDefaults(_ value: Any, forKey defaultsKey: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: defaultsKey.rawValue)
    }
    
    func getUserDefaultsObject(forKey defaultsKey: UserDefaultsKey) -> Any? {
        if let object = UserDefaults.standard.object(forKey: defaultsKey.rawValue) {
            return object
        } else {
            return nil
        }
    }
}
