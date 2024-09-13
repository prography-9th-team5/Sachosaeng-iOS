//
//  Bookmark.swift
//  Sachosaeng
//
//  Created by LJh on 9/10/24.
//

import Foundation

struct Bookmark: Codable, Identifiable {
    var voteBookmarkId: Int
    var voteId: Int
    var title: String
    var description: String
    var id: Int { return voteId }
}
