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
    @Published var currentVoteDetail: VoteDetail = dummyVoteDetail
    @Published var hotVotesWithSelectedCategory: HotVoteWithCategory = dummyHotVoteWithCategory
    @Published var hotVotesInCategory: [CategorizedVotes] = [dummyCategorizedVotes]
    @Published var latestVotes: LatestVote = dummyLatestVote
    /// 인기투표 3개를 가져오는 메서드
    func fetchHotVotes() {
        networkService.performRequest(method: "GET", path: "/api/v1/votes/hot", body: nil, token: nil) { (result: Result<Response<HotVote>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    hotVotes = votes.data
                    jhPrint(hotVotes)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    /// 전체 카테고리 투표를 3개씩 조회 (지금은 최신순 3개로 조회시킨다고함)
    func fetchHotVotesInCategory() {
        let path = "/api/v1/votes/suggestions/all"
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<[HotVoteWithCategory]>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    var categorizedVotes: [CategorizedVotes] = []
                    
                    for hotVote in votes.data {
                        if let index = categorizedVotes.firstIndex(where: { $0.category.categoryId == hotVote.category.categoryId }) {
                            categorizedVotes[index].votes.append(contentsOf: hotVote.votes)
                        } else {
                            categorizedVotes.append(CategorizedVotes(category: hotVote.category, votes: hotVote.votes))
                        }
                    }
                    
                    hotVotesInCategory = categorizedVotes
                    
//                    jhPrint(hotVotesInCategory)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    /// 사용자가 특정 카테고리를 눌렀을 경우 그에 맞는 인기 투표 3개를 나타내는 메서드
    func fetchHotVotesWithSelectedCategory(categoryId: Int) {
        let path = "/api/v1/votes/hot/categories/\(categoryId)"
        let token = UserStore.shared.accessToken

        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<HotVoteWithCategory>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    hotVotesWithSelectedCategory = votes.data
                    jhPrint("\(votes.data)")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchLatestVotesInSelectedCategory(categoryId: Int) {
        let path = "/api/v1/votes/categories/\(categoryId)"
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<LatestVote>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    latestVotes = votes.data
                    jhPrint(latestVotes)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    /// 오늘의 투표를 가져오는 메서드
    func fetchDailyVote() {
        let token = UserStore.shared.accessToken
        networkService.performRequest(method: "GET", path: "/api/v1/votes/daily", body: nil, token: token) {
            (result: Result<Response<Vote>, NetworkError>) in
            switch result {
            case .success(let vote):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    dailyVote = vote.data
                }
            case .failure(let error):
                jhPrint(error)
            }
        }
    }
    
    /// 투표의 선택지를 가져오는 메서드
    func fetchVoteDetail(voteId: Int) {
        let path = "/api/v1/votes/\(voteId)"
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<VoteDetail>, NetworkError>) in
            switch result {
            case .success(let voteDetail):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentVoteDetail = voteDetail.data
                }
            case .failure(let error):
                jhPrint(error)
            }
        }
    }
    
    /// 유저가 투표선택한 값을 넣어주는 api 
    func updateUserVoteChoices(voteId: Int, chosenVoteOptionIds: [Int]) {
        let path = "/api/v1/votes/\(voteId)/choices"
        let body = ["chosenVoteOptionIds": chosenVoteOptionIds]
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "PUT", path: path, body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success(let vote):
                jhPrint(vote.data)
            case .failure( _):
                break
            }
        }
    }
    
    func categoryID(_ categoryName: String) -> Int {
        switch categoryName {
        case "퇴사, 이직":
            return 1
        case "경조사":
            return 2
        case "비즈니스 매너":
            return 3
        case "대인 관계":
            return 5
        case "금융 생활":
            return 6
        case "조직 문화":
            return 7
        case "취업":
            return 8
        case "커리어":
            return 9
        case "업무 꿀팁":
            return 10
        default:
            return 400
        }
    }
}
