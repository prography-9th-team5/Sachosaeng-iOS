//
//  Auth.swift
//  Sachosaeng
//
//  Created by LJh on 8/17/24.
//

import Foundation

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
