//
//  VoteStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/23/24.
//
import Foundation

final class VoteStore: ObservableObject {
    private let networkService = NetworkService.shared
    
    @Published var hotVotes: HotVote = dummyHotVote
    @Published var dailyVote: Vote = dummyDailyVote
    @Published var currentDailyVoteDetail: VoteDetail = dummyVoteDetail
    @Published var hotVotesWithCategory: HotVoteWithCategory = dummyHotVoteWithCategory
    
    func fetchHotVotes() {
        networkService.performRequest(method: "GET", path: "/api/v1/votes/hot", body: nil, token: nil) { (result: Result<Response<HotVote>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    hotVotes = votes.data
//                    jhPrint(hotVotes)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchHotVotesWithCategory(categoryId: Int) {
        let path = "/api/v1/votes/hot/categories/\(categoryId)"
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: nil) { (result: Result<Response<HotVoteWithCategory>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    hotVotesWithCategory = votes.data
                    jhPrint(votes.data.votes)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchDailyVote() {
        networkService.performRequest(method: "GET", path: "/api/v1/votes/daily", body: nil, token: nil) {
            (result: Result<Response<Vote>, NetworkError>) in
            switch result {
            case .success(let vote):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    dailyVote = vote.data
//                    jhPrint("\(vote.data.isVoted), \(vote.data.voteId)")
                }
            case .failure(let error):
                jhPrint(error)
            }
        }
    }
    
    func fetchVoteDetail(voteId: Int) {
        let path = "/api/v1/votes/\(voteId)"
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<VoteDetail>, NetworkError>) in
            switch result {
            case .success(let voteDetail):
                DispatchQueue.main.async {[weak self] in
                    guard let self else { return }
                    currentDailyVoteDetail = voteDetail.data
                }
            case .failure(let error):
                jhPrint(error)
            }
        }
    }
    
    func updateUserVoteChoices(voteId: Int, chosenVoteOptionIds: [Int]) {
        let path = "/api/v1/votes/\(voteId)/choices"
        let body = ["chosenVoteOptionIds": chosenVoteOptionIds]
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "PUT", path: path, body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success( _):
                jhPrint("투표내용저장성공")
            case .failure( _):
                break
            }
        }
    }
}
