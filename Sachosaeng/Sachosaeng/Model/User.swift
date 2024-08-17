//
//  User.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import Foundation

struct User: Codable, Hashable {
    let userId: Int
    var nickname: String
    var userType: String
}
