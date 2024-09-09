//
//  BookmarkStore.swift
//  Sachosaeng
//
//  Created by LJh on 9/10/24.
//

import Foundation

class BookmarkStore: ObservableObject {
    @Published var currentUserVotesBookmark: [Bookmark] = []
    private let networkService = NetworkService.shared

    func fetchAllVotesBookmark() {
        let path = "/api/v1/bookmarks/votes"
        let token = UserStore.shared.accessToken

        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<[Bookmark]>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserVotesBookmark = bookmark.data
                    jhPrint(currentUserVotesBookmark)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func updateVotesBookmark(voteId: Int) {
        let path = "/api/v1/bookmarks/votes"
        let body = ["voteId": voteId]
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "POST", path: path, body: body, token: token) { (result: Result<ResponseEmptyWithTempData, NetworkError>) in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    jhPrint("북마크 등록 성공")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func deleteVotesBookmark(voteBookmarkIds: [Int]) {
        let path = "/api/v1/bookmarks/votes"
        let body = ["voteBookmarkIds": [voteBookmarkIds]]
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "DELETE", path: path, body: body, token: token) { (result: Result<ResponseEmptyWithTempData, NetworkError>) in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    jhPrint("북마크 삭제 성공")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
}