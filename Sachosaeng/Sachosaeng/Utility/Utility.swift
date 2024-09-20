//
//  Utility.swift
//  Sachosaeng
//
//  Created by LJh on 7/24/24.
//

import Foundation


public func jhPrint(_ object: Any, isWarning: Bool = false, filename: String = #file, _ line: Int = #line, _ funcname: String = #function) {
    if isWarning {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        print("""
          🚨 Log!! : \(dateFormatter.string(from: Date()))
          🚨 file: \(filename)
          🚨 line: \(line) , 🚨 func: \(funcname)
          """)
        print(object)
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        print("""
          ⭐️ Log!! : \(dateFormatter.string(from: Date()))
          ⭐️ file: \(filename)
          ⭐️ line: \(line) , ⭐️ func: \(funcname)
          """)
        print(object)
    }
}
