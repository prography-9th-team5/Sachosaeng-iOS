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
    let votes: [VoteOptionForHotVoteWithCategory]
}

struct VoteOptionForHotVoteWithCategory: Codable, Hashable, Identifiable {
    let voteId: Int
    let title: String
    let participantCount: Int?
    let isVoted: Bool
    let isClosed: Bool
    var id: Int { return voteId }
}

let dummyHotVote = HotVote(category: dummyHotCategory, votes: [dummyVote])
let dummyVoteForHotVoteWithCategory = VoteOptionForHotVoteWithCategory(voteId: 0, title: "", participantCount: 0, isVoted: true, isClosed: true)
let dummyHotVoteWithCategory = HotVoteWithCategory(category: dummyCategory, description: "", votes: [dummyVoteForHotVoteWithCategory])
