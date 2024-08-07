//
//  Vote.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct HotVote: Codable, Hashable {
    let category: HotCategory
    let votes: [Vote]
}

struct Vote: Codable, Hashable, Identifiable {
    let voteId: Int
    let title: String
    let participantCount: Int?
    let isVoted: Bool
    let category: Category
    var id: Int { voteId }
}

struct VoteDetail: Codable {
    let voteId: Int
    let isClosed, isVoted: Bool
    let chosenVoteOptionID: [Int]
    let category: Category
    let title: String
    let participantCount: Int?
    let voteOptions: [VoteOption]
    let description: String
}

struct VoteOption: Codable {
    let voteOptionId: Int
    let content: String
    let count: Int
}

let dummyVote = Vote(voteId: 2, title: "더미", participantCount: 0, isVoted: false, category: Sachosaeng.Category(categoryId: 7, name: "조직 문화", iconUrl: "https://sachosaeng.store/icon/organizational-culture-18px-1x.png", backgroundColor: "#1F0BA5EC", textColor: "#FF0BA5EC"))
let dummyHotvote = HotVote(category: dummyHotCategory, votes: [dummyVote])
let dummyOption = VoteOption(voteOptionId: 0, content: "", count: 0)
let dummyVoteDetail = VoteDetail(voteId: 0, isClosed: false, isVoted: false, chosenVoteOptionID: [0], category: dummyCategory, title: "", participantCount: 0, voteOptions: [dummyOption], description: "")
