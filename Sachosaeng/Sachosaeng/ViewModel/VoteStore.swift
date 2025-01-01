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
    @Published var currentVoteInformation: [Information] = []
    @Published var currentVoteInformationDetail: InformationDetail = dummyInformationDetail
    @Published var currentRegisteredVote: RegisteredVote = dummyRegisteredVote
    @Published var hotVotesWithSelectedCategory: HotVoteWithCategory = dummyHotVoteWithCategory
    @Published var hotVotesInCategory: [CategorizedVotes] = [dummyCategorizedVotes]
    @Published var latestVotes: LatestVote = dummyLatestVote
    @Published var registeredHistory: [History] = []
    @Published var nextCursorForVote: Int?
    @Published var categoryName: String = "전체"
    @Published var categoryNameForBookmark: String = "ALL"
    @Published var nextCursorForHistory: Int?
    
    private var token = KeychainService.shared.getSachoSaengAccessToken()
    func reset() {
        hotVotes = dummyHotVote
        dailyVote = dummyDailyVote
        currentVoteDetail = dummyVoteDetail
        currentVoteInformation = []
        currentVoteInformationDetail = dummyInformationDetail
        hotVotesWithSelectedCategory = dummyHotVoteWithCategory
        hotVotesInCategory = [dummyCategorizedVotes]
        latestVotes = dummyLatestVote
        categoryName = "전체"
        categoryNameForBookmark = "ALL"
    }
    
    /// 인기투표 3개를 가져오는 메서드
    func fetchHotVotes() {
        networkService.performRequest(method: "GET", path: "/api/v1/votes/hot", body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) { (result: Result<Response<HotVote>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    hotVotes = votes.data
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    /// 전체 카테고리 투표를 3개씩 조회 (지금은 최신순 3개로 조회시킨다고함)
    func fetchHotVotesInCategory() {
        let path = "/api/v1/votes/suggestions/all"
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) { (result: Result<Response<ResponseHotvoteWithCategory>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    var categorizedVotes: [CategorizedVotes] = []
                    
                    for hotVote in votes.data.categories {
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

        networkService.performRequest(method: "GET", path: path, body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) { (result: Result<Response<HotVoteWithCategory>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    hotVotesWithSelectedCategory = votes.data
//                    jhPrint("\(votes.data)")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchLatestVotesInSelectedCategory(categoryId: Int, cursor: Int? = nil, size: Int = 10) {
        var path = "/api/v1/votes/categories/\(categoryId)?size=\(size)"
        if let cursor = cursor {
            path += "&cursor=\(cursor)"
        }
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) { (result: Result<Response<LatestVote>, NetworkError>) in
            switch result {
            case .success(let votes):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    latestVotes = votes.data
                    
                    if votes.data.hasNext {
                        nextCursorForVote = votes.data.nextCursor
                    } else {
                        nextCursorForVote = nil
                    }
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchLatestVoteWithCursor(categoryId: Int) {
        guard let nextCursor = latestVotes.nextCursor else { return }
        
        let path = "/api/v1/votes/categories/\(categoryId)?size=\(10)&cursor=\(nextCursor)"
        jhPrint("카테고리 \(categoryId)")
        networkService.performRequest(method: "GET", path: path, body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) { (result: Result<Response<LatestVote>, NetworkError>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                    case .success(let response):
                        latestVotes.votes.append(contentsOf: response.data.votes)
                        latestVotes.hasNext = response.data.hasNext
                        latestVotes.nextCursor = response.data.nextCursor
                    case .failure(let error):
                        jhPrint(error.localizedDescription)
                }
            }
        }
    }
    
    /// 오늘의 투표를 가져오는 메서드
    func fetchDailyVote(completion: @escaping (Bool) -> ()) {
        networkService.performRequest(method: "GET", path: "/api/v1/votes/daily", body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) {
            (result: Result<Response<Vote>, NetworkError>) in
            switch result {
            case .success(let vote):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    dailyVote = vote.data
//                    jhPrint("서버에서 사용자가 투표했나요?: \(dailyVote.isVoted)", isWarning: true)
                    completion(dailyVote.isVoted)
                    
                }
            case .failure(let error):
                jhPrint(error, isWarning: true)
            }
        }
    }
    
    /// 투표의 선택지를 가져오는 메서드
    func fetchVoteDetail(voteId: Int, categoryId: Int? = nil, completion: @escaping (Bool) -> Void) {
        var path = "/api/v1/votes/\(voteId)"
        if let categoryId = categoryId {
            path += "?category-id=\(categoryId)"
        }
        networkService.performRequest(method: "GET", path: path, body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) { (result: Result<Response<VoteDetail>, NetworkError>) in
            switch result {
            case .success(let voteDetail):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentVoteDetail = voteDetail.data
//                    jhPrint(currentVoteDetail)
                    completion(true)
                }
            case .failure(let error):
                    completion(false)
                jhPrint(error, isWarning: true)
            }
        }
    }
    
    /// 유저가 투표선택한 값을 넣어주는 api 
    func updateUserVoteChoices(voteId: Int, chosenVoteOptionIds: [Int], completion: @escaping (Bool) -> Void) {
        let path = "/api/v1/votes/\(voteId)/choices"
        let body = ["chosenVoteOptionIds": chosenVoteOptionIds]
        jhPrint(body)
        networkService.performRequest(method: "PUT", path: path, body: body, token: KeychainService.shared.getSachoSaengAccessToken()!) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success( _):
                completion(true)
            case .failure(let error):
                completion(false)
                jhPrint(error, isWarning: true)
            }
        }
    }
    
    /// 유저가 투표를 등록할수 있게 하는 메서드
    func registrationVote(title: String, isMulti: Bool, voteOptions: [String], categoryIds: Int, completion: @escaping (Bool) -> Void) {
        let path = "/api/v1/votes"
        let body: [String: Any] = [
            "title": title,
            "isMultipleChoiceAllowed": isMulti,
            "voteOptions": voteOptions,
            "categoryIds": [categoryIds]
        ]
        networkService.performRequest(method: "POST", path: path, body: body, token: KeychainService.shared.getSachoSaengAccessToken()!) {(result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
                case .success(_):
                    jhPrint("등록성공")
                    completion(true)
                case .failure(let err):
                    jhPrint(err.localizedDescription)
                    completion(false)
            }
        }
    }
    
    /// 사용자 투표 히스토리 조회
    func fetchHistory() async {
        let path = "/api/v1/votes/my"
        
        guard let token = KeychainService.shared.getSachoSaengAccessToken() else {
            jhPrint("토큰이 존재하지 않습니다.")
            return
        }
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<HistoryData>, NetworkError>) in
            switch result {
            case .success(let history):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    if history.data.hasNext {
                        nextCursorForHistory = history.data.nextCursor
                    }
                    registeredHistory = history.data.votes
                }
            case .failure(let err):
                jhPrint(err.localizedDescription)
            }
        }
    }
    
    func fetchHistory(size: Int = 10, completion: @escaping (Bool) -> Void) {
        var path = "/api/v1/votes/my?size=\(size)"
        
        if let cursor = nextCursorForHistory {
            path += "&cursor=\(cursor)"
        }
        
        guard let token = KeychainService.shared.getSachoSaengAccessToken() else {
            jhPrint("토큰이 존재하지 않습니다.")
            return
        }
        
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<HistoryData>, NetworkError>) in
            switch result {
            case .success(let history):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    let cursor = history.data.nextCursor
                    
                    if history.data.hasNext {
                        nextCursorForHistory = cursor
                        registeredHistory.append(contentsOf: history.data.votes)
                        completion(false)
                    } else {
                        registeredHistory.append(contentsOf: history.data.votes)
                        jhPrint("false: \(history.data)")
                        completion(true)
                    }
                }
            case .failure(let err):
                jhPrint(err.localizedDescription)
                completion(true)
            }
        }
    }
    
    /// 단일 등록된 투표 상세 조회 
    func fetchRegisteredVote(voteId: Int) {
        let path = "/api/v1/votes/my/\(voteId)"
        guard let token = KeychainService.shared.getSachoSaengAccessToken() else {
            jhPrint("토큰이 존재하지 않습니다.")
            return
        }
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<RegisteredVote>, NetworkError>) in
            switch result {
            case .success(let vote):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentRegisteredVote = vote.data
                }
            case .failure(let err):
                jhPrint(err.localizedDescription)
            }
        }
    }
    
    func searchInformation(categoryId: Int, voteId: Int, completion: @escaping (Bool) -> Void) {
        let path = "/api/v1/similar-information?category-id=\(categoryId)&vote-id=\(voteId)"
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) {(result: Result<Response<ResponseinformationData>, NetworkError>) in
            switch result {
            case .success(let information):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentVoteInformation = information.data.information
                    completion(true)
                }
            case .failure(let error):
                jhPrint(error)
                completion(false)
            }
        }
    }
    
    func fetchInformation(informationId: Int) {
        let path = "/api/v1/information/\(informationId)"

        networkService.performRequest(method: "GET", path: path, body: nil, token: KeychainService.shared.getSachoSaengAccessToken()!) { (result: Result<Response<InformationDetail>, NetworkError>) in
            switch result {
            case .success(let informationDetail):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentVoteInformationDetail = informationDetail.data
                }
            case .failure(let error):
                jhPrint(error)
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
