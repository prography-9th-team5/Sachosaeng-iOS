//
//  VoteStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/23/24.
//
import Foundation

final class VoteStore: ObservableObject {
    @Published var hotVotes: HotVote = HotVote(category: dummyHotCategory, votes: [dummyVote])
    @Published var dailyVote: Vote = dummyVote
    @Published var test = dummyVoteDetail
    
    func fetchHotVotes() async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/hot") { (result: Result<HotVote, Error>) in
            switch result {
            case .success(let hotVotes):
                DispatchQueue.main.async {
                    self.hotVotes = hotVotes
                    myLogPrint("🎉 성공: \(self.hotVotes)", isTest: true)
                }
            case .failure(let error):
                myLogPrint("🚨 에러: \(error)", isTest: false)
            }
        }
    }
    
    func fetchDaily() async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/daily") { (result: Result<Vote, Error> ) in
            switch result {
            case .success(let dailyVote):
                DispatchQueue.main.async {
                    self.dailyVote = dailyVote
                    myLogPrint("🎉 성공: \(self.dailyVote)", isTest: false)
                }
            case .failure(let error):
                myLogPrint("🚨 에러: \(error)", isTest: false)
            }
        }
    }
    
    func fetchVoteDetail(voteId: Int) async {
        fetchData(from: "https://sachosaeng.store/api/v1/votes/{\(voteId)}") {(result: Result<VoteDetail, Error> ) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.test = result
                    myLogPrint("🎉 성공: \(self.test)", isTest: false)
                }
            case .failure(let error):
                myLogPrint("🚨 에러: \(error)", isTest: false)
            }
        }
    }
}
