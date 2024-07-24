//
//  VoteStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/23/24.
//

import Foundation

final class VoteStore: ObservableObject {
    @Published var hotVotes: HotVote = HotVote(category: dummyCategory, votes: [dummyVote])
    @Published var dailyVote: Vote = dummyVote
    
    func fetchHotVotes() async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/hot") { (result: Result<HotVote, Error>) in
            switch result {
            case .success(let hotVotes):
                DispatchQueue.main.async {
                    self.hotVotes = hotVotes
//                    print("🎉 성공: fetchHotVotes() \(self.hotVotes)")
                }
            case .failure(let error):
                print("🚨 에러: fetchHotVotes() 실패 🚨: \(error)")
            }
        }
    }
    
    func fetchDaily() async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/daily") { (result: Result<Vote, Error> ) in
            switch result {
            case .success(let dailyVote):
                DispatchQueue.main.async {
                    self.dailyVote = dailyVote
                    print("🎉 성공: fetchDaily() \(self.dailyVote)")
                }
            case .failure(let error):
                print("🚨 에러: fetchDaily() 실패 🚨: \(error)")
            }
        }
    }
}
