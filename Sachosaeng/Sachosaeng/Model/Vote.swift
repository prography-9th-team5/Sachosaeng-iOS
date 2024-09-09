//
//  Vote.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct Vote: Codable, Hashable, Identifiable {
    let voteId: Int
    let title: String
    let participantCount: Int?
    let isVoted: Bool
    let category: Category
    let isClosed: Bool
    var id: Int { voteId }
}

struct VoteDetail: Codable {
    var voteId: Int
    var isClosed, isVoted: Bool
    var isBookmarked: Bool
    var chosenVoteOptionID: [Int]?
    var category: Category
    var title: String
    var participantCount: Int
    var voteOptions: [VoteOption]
    var description: String
}

struct VoteOption: Codable, Hashable, Identifiable {
    let voteOptionId: Int
    let content: String
    let count: Int
    var id: Int { voteOptionId }
}

struct LatestVote: Codable {
    var votes: [VoteWithoutCategory]
    var hasNext: Bool
    var nextCursor: Int?
}
struct CategorizedVotes: Codable, Identifiable {
    var category: Category
    var votes: [VoteWithoutCategory]
    var id: Int { category.id }
}
let dummyVoteDetail = VoteDetail(
    voteId: 101,
    isClosed: false,
    isVoted: true, isBookmarked: true,
    chosenVoteOptionID: [1],
    category: dummyCategory,
    title: "Which technology will dominate in 2024?",
    participantCount: 35,
    voteOptions: dummyVoteOptions,
    description: "Vote on the technology trend you think will lead in 2024."
)

let dummyDailyVote = Vote(voteId: 2, title: "더미", participantCount: 0, isVoted: false, category: Sachosaeng.Category(categoryId: 7, name: "조직 문화", iconUrl: "https://sachosaeng.store/icon/organizational-culture-18px-1x.png", backgroundColor: "#1F0BA5EC", textColor: "#FF0BA5EC"), isClosed: false)
let dummyOption = VoteOption(voteOptionId: 0, content: "", count: 0)
// VoteOption 더미 데이터
let dummyVoteOptions = [
    VoteOption(voteOptionId: 1, content: "Option 1", count: 10),
    VoteOption(voteOptionId: 2, content: "Option 2", count: 20),
    VoteOption(voteOptionId: 3, content: "Option 3", count: 5)
]
let dummyVote = Vote(voteId: 0, title: "", participantCount: 1, isVoted: false, category: dummyCategory, isClosed: false)
let dummyLatestVote = LatestVote(votes: [dummyVoteWithoutCategory], hasNext: true, nextCursor: 0)
