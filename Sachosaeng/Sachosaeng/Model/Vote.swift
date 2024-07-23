//
//  Vote.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct ResponseDailyVote: Codable {
    let code: Int
    let message: String
    let data: Vote
}

struct ResponseHotVote: Codable {
    let code: Int
    let message: String
    let data: [HotVote]
}

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

    enum CodingKeys: String, CodingKey {
       case voteId = "voteId"
       case title = "title"
       case participantCount = "participantCount"
       case isVoted = "isVoted"
       case category = "category"
    }
}

let dummyVote = Vote(voteId: 2, title: "가장 좋은 회사 복지는 무엇인가요?", participantCount: 0, isVoted: false, category: Sachosaeng.Category(categoryId: 7, name: "조직 문화", iconUrl: "https://sachosaeng.store/icon/organizational-culture-18px-1x.png", backgroundColor: "#1F0BA5EC", textColor: "#FF0BA5EC"))
let dummyHotvote = HotVote(category: dummyCategory, votes: [dummyVote])
