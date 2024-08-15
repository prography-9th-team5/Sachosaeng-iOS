//
//  VoteStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/23/24.
//
import Foundation

final class VoteStore: ObservableObject {
    @Published var hotVotes: HotVote = HotVote(category: dummyHotCategory, votes: [dummyDailyVote])
    @Published var dailyVote: Vote = dummyDailyVote
    @Published var test = dummyVoteDetail
    
    func fetchHotVotes() async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/hot") { (result: Result<HotVote, Error>) in
            switch result {
            case .success(let hotVotes):
                DispatchQueue.main.async {
                    self.hotVotes = hotVotes
                    
                }
            case .failure(let error):
//                jhPrint("🚨 에러: \(error)", isWarning: true)
                break
            }
        }
    }
    
    func fetchDaily() async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/daily") { (result: Result<Vote, Error> ) in
            switch result {
            case .success(let dailyVote):
                DispatchQueue.main.async {
                    self.dailyVote = dailyVote
                    
                }
            case .failure(let error):
                    break
            }
        }
    }
    
    func fetchVoteDetail(voteId: Int) async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/{\(voteId)}") {(result: Result<VoteDetail, Error> ) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.test = result
                }
            case .failure(let error):
                break
            }
        }
    }
}
