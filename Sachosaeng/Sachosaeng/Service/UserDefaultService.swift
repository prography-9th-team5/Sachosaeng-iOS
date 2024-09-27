//
//  UserDefaultService.swift
//  Sachosaeng
//
//  Created by LJh on 9/27/24.
//

import Foundation

enum UserDefaultsKey: String {
    case signType = "SignType"
}

extension UserDefaults {
    func setValue(_ value: Any?, forKey key: UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }
    
    func string(forKey key: UserDefaultsKey) -> String? {
        return string(forKey: key.rawValue)
    }
        
    func bool(forKey key: UserDefaultsKey) -> Bool {
        return bool(forKey: key.rawValue)
    }
    func removeObject(forKey key: UserDefaultsKey) {
        removeObject(forKey: key.rawValue)
    }
}
