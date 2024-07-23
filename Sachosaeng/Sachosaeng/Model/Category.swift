//
//  Category.swift
//  Sachosaeng
//
//  Created by LJh on 7/3/24.
//

import Foundation

struct ResponseCategory: Codable {
    let code: Int
    let message: String
    let data: [Category]
}

struct Category: Codable, Identifiable, Hashable {
    let categoryId: Int
    let name: String
    let iconUrl: String
    let backgroundColor: String
    let textColor: String
    var id: Int { categoryId }
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "categoryId"
        case name = "name"
        case iconUrl = "iconUrl"
        case backgroundColor = "backgroundColor"
        case textColor = "textColor"
    }
}

struct ResponseAllCategory: Codable {
    let code: Int
    let message: String
    let data: allCategory
}
struct allCategory: Codable {
    let iconUrl: String
    let backgroundColor: String
}
let dummyCategory = Category(categoryId: 1, name: "", iconUrl: "", backgroundColor: "", textColor: "")
