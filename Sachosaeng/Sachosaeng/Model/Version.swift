//
//  Version.swift
//  Sachosaeng
//
//  Created by LJh on 9/15/24.
//

import Foundation

struct Version: Codable {
    var version: String
    var platform: String
    var isLatest: Bool
    var forceUpdateRequired: Bool
}
