//
//  User.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import Foundation

struct ResponseUser: Codable, Hashable {
    let code: Int
    let message: String
    let data: User
}

struct User: Codable, Hashable {
    let userId: Int
    var nickname: String
    var userType: String
}

struct AuthResponse: Codable {
    let code: Int
    let data: AuthData
    let message: String
}

struct AuthData: Codable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
}
