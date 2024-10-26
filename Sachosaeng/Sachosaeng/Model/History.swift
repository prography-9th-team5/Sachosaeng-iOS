//
//  History.swift
//  Sachosaeng
//
//  Created by LJh on 10/24/24.
//

import Foundation

struct HistoryData: Codable {
    let votes: [History]
    let hasNext: Bool
    let nextCursor: Int
}

struct History: Codable, Identifiable {
    let voteId: Int
    let title: String
    let status: String
    var id: Int { voteId }
}

struct RegisteredVote: Codable, Identifiable {
    let voteId: Int
    let status: String
    let title: String
    let isMultipleChoiceAllowed: Bool
    let voteOptions: [String]
    let categories: [Category]
    var id: Int { voteId }
}

enum HistoryType: String {
    case approved = "APPROVED"
    case rejected = "REJECTED"
    case pending = "PENDING"
}
let dummyRegisteredVote = RegisteredVote(voteId: 0, status: "", title: "", isMultipleChoiceAllowed: true, voteOptions: [""], categories: [dummyCategory])
