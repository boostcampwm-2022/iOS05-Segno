//
//  LocalUtilityRepository.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/14.
//

import Foundation

protocol LocalUtilityRepository {
    func createToken(key: Any, token: Any) -> Bool
    func getToken(key: Any) -> Any?
    func updateToken(key: Any, token: Any) -> Bool
    func deleteToken(key: Any) -> Bool
    func setUserDefaults(_ value: Any, forKey defaultsKey: UserDefaultsKey)
    func getUserDefaultsObject(forKey defaultsKey: UserDefaultsKey) -> Any?
}

final class LocalUtilityRepositoryImpl: LocalUtilityRepository {
    func createToken(key: Any, token: Any) -> Bool {
        let token = (token as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
        let addQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: token
        ]
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        if status == errSecSuccess { return true }
        else if status == errSecDuplicateItem {
            // MARK: 기존에는 Error만 return 해주었지만, Error 출력 후 자체적으로 update까지 진행
            print(KeychainError.duplicatedKey)
            return updateToken(key: key, token: token)
        }
        
        print(KeychainError.unhandledError(status: status))
        return false
    }
    
    func getToken(key: Any) -> Any? {
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
                return token
            }
        }
        
        print(KeychainError.unexpectedToken)
        return nil
    }
    
    func updateToken(key: Any, token: Any) -> Bool {
        let prevQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let token = (token as AnyObject).data(using: String.Encoding.utf8.rawValue)!
        let updateQuery: [String: Any] = [ kSecValueData as String: token as Any ]
        
        let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
        if status == errSecSuccess { return true }
        
        print(KeychainError.unhandledError(status: status))
        return false
    }
    
    func deleteToken(key: Any) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess { return true }
        
        print(KeychainError.unhandledError(status: status))
        return false
    }
    
    func setUserDefaults(_ value: Any, forKey defaultsKey: UserDefaultsKey) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: defaultsKey.rawValue)
    }
    
    func getUserDefaultsObject(forKey defaultsKey: UserDefaultsKey) -> Any? {
        let defaults = UserDefaults.standard
        if let object = defaults.object(forKey: defaultsKey.rawValue) {
            return object
        } else {
            return nil
        }
    }
}
