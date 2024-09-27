//
//  KeychainService.swift
//  Sachosaeng
//
//  Created by LJh on 9/27/24.
//

import Foundation

enum KeychainServiceKey: String {
    case sachosaengAccessToken = "SachoSaengAccessToken"
    case sachosaengRefreshToken = "SachoSaengRefreshToken"
    case appleUserID = "appleUserID"
    case appleToken = "appleToken"
    case oauthToken = "oauthToken"
    case userEmail = "userEmail"
}

class KeychainService {
    static let shared = KeychainService()
    
    func save(key: KeychainServiceKey, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func load(key: KeychainServiceKey) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }

    func delete(key: KeychainServiceKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    func getSachoSaengAccessToken() -> String? {
        guard let data = KeychainService.shared.load(key: .sachosaengAccessToken),
              let token = String(data: data, encoding: .utf8) else {
            jhPrint("getSachoSaengAccessToken이 없습니다.", isWarning: true)
            return nil
        }
        return token
    }
    
    func getSachosaengRefreshToken() -> String? {
        guard let data = KeychainService.shared.load(key: .sachosaengRefreshToken),
              let token = String(data: data, encoding: .utf8) else {
//            jhPrint("SachosaengRefreshToken이 없습니다.", isWarning: true)
            return nil
        }
        return token
    }
    
    func getOauthToken() -> String? {
        guard let data = KeychainService.shared.load(key: .oauthToken),
              let token = String(data: data, encoding: .utf8) else {
            jhPrint("oauthToken이 없습니다.", isWarning: true)
            return nil
        }
        return token
    }
    func getAppleUserId() -> String? {
        guard let data = KeychainService.shared.load(key: .appleUserID),
              let token = String(data: data, encoding: .utf8) else {
            jhPrint("appleUserID이 없습니다.", isWarning: true)
            return nil
        }
        return token
    }
    func getUserEmail() -> String? {
        guard let data = KeychainService.shared.load(key: .userEmail),
          let token = String(data: data, encoding: .utf8) else {
            jhPrint("Email이 없습니다.", isWarning: true)
            return nil
        }
        return token
    }
    func deleteAll() {
        let allKeys: [KeychainServiceKey] = [
            .sachosaengAccessToken,
            .sachosaengRefreshToken,
            .appleToken,
            .oauthToken,
            .appleUserID,
            .userEmail
            // 여기에 다른 KeychainServiceKey 열거형 값들도 추가하세요.
        ]
        
        for key in allKeys {
            let isDeleted = delete(key: key)
            if isDeleted {
                jhPrint("\(key.rawValue) 삭제 완료")
            } else {
                jhPrint("\(key.rawValue) 삭제 실패", isWarning: true)
            }
        }
    }
}
