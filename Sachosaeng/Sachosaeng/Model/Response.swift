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

struct ResponseCategoriesData: Codable {
    let categories: [Category]
}

struct ResponseHotvoteWithCategory: Codable {
    let categories: [HotVoteWithCategory]
}

struct ResponseinformationData: Codable {
    let information: [Information]
}

struct ResponseBookmark: Codable {
    let votes: [Bookmark]
}

struct ResponseInformation: Codable {
    let information: [InformationInBookmark]
    let hasNext: Bool
    let nextCursor: Int?
}

struct ReponseVersion: Codable {
    let versions: [Version]
}

struct ResponseWithTempData<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T?
}

struct EmptyData: Codable {}
