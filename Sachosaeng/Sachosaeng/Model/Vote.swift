//
//  Vote.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct HotVote: Codable, Hashable {
    let category: Category
    let votes: [Vote]
}

struct Vote: Codable, Hashable, Identifiable {
    let voteId: Int
    let title: String
    let participantCount: Int
    let isVoted: Bool
    let category: Category
    var id: Int { voteId }
}

struct VoteDetail: Codable {
    let voteID: Int
    let isClosed, isVoted: Bool
    let chosenVoteOptionID: [Int]
    let category: Category
    let title: String
    let participantCount: Int
    let voteOptions: [VoteOption]
    let description: String
}

struct VoteOption: Codable {
    let voteOptionID: Int
    let content: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case voteOptionID = "voteOptionId"
        case content, count
    }
}
let dummyVote = Vote(voteId: 2, title: "가장 좋은 회사 복지는 무엇인가요?", participantCount: 0, isVoted: false, category: Sachosaeng.Category(categoryId: 7, name: "조직 문화", iconUrl: "https://sachosaeng.store/icon/organizational-culture-18px-1x.png", backgroundColor: "#1F0BA5EC", textColor: "#FF0BA5EC"))
let dummyHotvote = HotVote(category: dummyCategory, votes: [dummyVote])
