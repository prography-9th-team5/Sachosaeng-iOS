//
//  History.swift
//  Sachosaeng
//
//  Created by LJh on 10/24/24.
//

import Foundation

struct History: Codable, Identifiable {
    let voteId: Int
    let title: String
    let status: String
    var id: Int { voteId }
}

enum HistoryType {
    case pending
    case approved
    case rejected
}
