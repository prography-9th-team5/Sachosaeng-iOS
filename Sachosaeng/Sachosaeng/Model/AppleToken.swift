//
//  AppleToken.swift
//  Sachosaeng
//
//  Created by LJh on 9/27/24.
//

import Foundation

struct AppleJWT: Codable {
    var access_token: String?
    var token_type: String?
    var expires_in: Int?
    var refresh_token: String?
    var id_token: String?

    enum CodingKeys: String, CodingKey {
        case refresh_token = "refresh_token"
    }
}
