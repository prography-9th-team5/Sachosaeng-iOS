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
    let isClosed: Bool
    var id: Int { voteId }
}
/*
 {
   "code": 0,
   "message": "string",
   "data": {
     "voteId": 0,
     "title": "string",
     "participantCount": 0,
     "isVoted": true,
     "category": {
       "categoryId": 0,
       "name": "string",
       "iconUrl": "string",
       "backgroundColor": "string",
       "textColor": "string"
     },
     "isClosed": true
   }
 }
 */
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

let dummyDailyVote = Vote(voteId: 2, title: "더미", participantCount: 0, isVoted: false, category: Sachosaeng.Category(categoryId: 7, name: "조직 문화", iconUrl: "https://sachosaeng.store/icon/organizational-culture-18px-1x.png", backgroundColor: "#1F0BA5EC", textColor: "#FF0BA5EC"), isClosed: false)
let dummyHotvote = HotVote(category: dummyHotCategory, votes: [dummyDailyVote])
let dummyOption = VoteOption(voteOptionId: 0, content: "", count: 0)
let dummyVoteDetail = VoteDetail(voteId: 0, isClosed: false, isVoted: false, chosenVoteOptionID: [0], category: dummyCategory, title: "", participantCount: 0, voteOptions: [dummyOption], description: "")
