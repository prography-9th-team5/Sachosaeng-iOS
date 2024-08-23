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
    let category: Category
    let description: String
    let votes: [VoteForHotVoteWithCategory]
}

struct VoteForHotVoteWithCategory: Codable, Hashable {
    let voteId: Int
    let title: String
    let participantCount: Int?
    let isVoted: Bool
    let isClosed: Bool
}

let dummyHotVote = HotVote(category: dummyHotCategory, votes: [dummyVote])
let dummyVoteForHotVoteWithCategory = VoteForHotVoteWithCategory(voteId: 0, title: "", participantCount: 0, isVoted: true, isClosed: true)
let dummyHotVoteWithCategory = HotVoteWithCategory(category: dummyCategory, description: "", votes: [dummyVoteForHotVoteWithCategory])
