//
//  HotVote.swift
//  Sachosaeng
//
//  Created by LJh on 8/23/24.
//

import Foundation

struct HotVote: Codable, Hashable {
    let category: CategoryForHotVote
    let votes: [Vote]
}

struct HotVoteWithCategory: Codable, Hashable {
    var category: Category
    var description: String?
    var votes: [VoteWithoutCategory]
}

struct VoteWithoutCategory: Codable, Hashable, Identifiable {
    var voteId: Int
    var title: String
    var participantCount: Int?
    var isVoted: Bool
    var isClosed: Bool
    var id: Int { return voteId }
}

let dummyHotVote = HotVote(category: dummyHotCategory, votes: [dummyVote])
let dummyVoteWithoutCategory = VoteWithoutCategory(voteId: 0, title: "", participantCount: 0, isVoted: true, isClosed: true)
let dummyHotVoteWithCategory = HotVoteWithCategory(category: dummyCategory, description: "", votes: [dummyVoteWithoutCategory])
