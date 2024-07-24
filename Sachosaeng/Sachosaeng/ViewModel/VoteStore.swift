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
    @Published var test = dummyVoteDetail
    
    var istest: Bool = false
    func fetchHotVotes() async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/hot") { (result: Result<HotVote, Error>) in
            switch result {
            case .success(let hotVotes):
                DispatchQueue.main.async {
                    self.hotVotes = hotVotes
//                    print("🎉 성공: fetchHotVotes() \(self.hotVotes)")
                }
            case .failure(let error):
                if self.istest {
                    print("🚨 에러: fetchHotVotes() 실패 🚨: \(error)")
                }
            }
        }
    }
    
    func fetchDaily() async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/daily") { (result: Result<Vote, Error> ) in
            switch result {
            case .success(let dailyVote):
                DispatchQueue.main.async {
                    self.dailyVote = dailyVote
                    if self.istest {
                        print("🎉 성공: fetchDaily() \(self.dailyVote)")
                    }
                }
            case .failure(let error):
                if self.istest {
                    print("🚨 에러: fetchDaily() 실패 🚨: \(error)")
                }
            }
        }
    }
    func fetchVoteDetail(voteId: Int) async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/{\(voteId)}") {(result: Result<VoteDetail, Error> ) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.test = result
                    if self.istest {
                        print("🎉 성공: fetchVoteDetail() \(self.test)")
                    }
                }
            case .failure(let error):
                if self.istest {
                    print("🚨 에러: fetchVoteDetail() 실패 🚨: \(error)")
                }
            }
        }
    }
}
