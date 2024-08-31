//
//  Imformation.swift
//  Sachosaeng
//
//  Created by LJh on 8/31/24.
//

import Foundation

struct Information: Codable, Hashable, Identifiable {
    var informationId: Int
    var title: String
    var id: Int { informationId }
}

struct InformationDetail: Codable, Hashable {
    var informationId: Int
    var title: String
    var subtitle: String?
    var content: String
    var category: Category
    var referenceName: String
}
