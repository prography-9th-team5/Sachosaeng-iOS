//
//  Response.swift
//  Sachosaeng
//
//  Created by LJh on 7/24/24.
//

import Foundation

struct Response<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T
    init(code: Int, message: String, data: T) {
        self.code = code
        self.message = message
        self.data = data
    }
}

struct ResponseWithTempData<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T?
}

struct EmptyData: Codable {}
