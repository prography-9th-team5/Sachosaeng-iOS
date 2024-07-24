//
//  Category.swift
//  Sachosaeng
//
//  Created by LJh on 7/3/24.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    let categoryId: Int
    let name: String
    let iconUrl: String
    let backgroundColor: String
    let textColor: String
    var id: Int { categoryId }
}

struct AllCategory: Codable {
    let iconUrl: String
    let backgroundColor: String
}

let dummyCategory = Category(categoryId: 1, name: "", iconUrl: "", backgroundColor: "", textColor: "")
