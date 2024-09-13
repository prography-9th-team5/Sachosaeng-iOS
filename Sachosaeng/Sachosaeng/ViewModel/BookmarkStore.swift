//
//  BookmarkStore.swift
//  Sachosaeng
//
//  Created by LJh on 9/10/24.
//

import Foundation

class BookmarkStore: ObservableObject {
    @Published var currentUserVotesBookmark: [Bookmark] = []
    @Published var currentUserInformationBookmark: [InformationInBookmark] = []
    @Published var editBookmarkNumber: [Int] = []
    private let networkService = NetworkService.shared

    func fetchAllVotesBookmark() {
        let path = "/api/v1/bookmarks/votes"
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseBookmark>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserVotesBookmark = bookmark.data.votes
                    jhPrint(currentUserVotesBookmark)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func deleteAllVotesBookmark(bookmarkId: [Int], completion: @escaping () -> Void) {
        let path = "/api/v1/bookmarks/votes"
        let body = ["voteBookmarkIds": bookmarkId]
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "DELETE", path: path, body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success( _):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    currentUserVotesBookmark.removeAll { bookmarkId.contains($0.voteBookmarkId) }
                    editBookmarkNumber.removeAll()

                    jhPrint("북마크 배열 삭제 성공")
                    completion()
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
        
        networkService.performRequest(method: "POST", path: path, body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
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
    
    func deleteVotesBookmark(voteId: Int) {
        let path = "/api/v1/bookmarks/votes/\(voteId)"
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "DELETE", path: path, body: nil, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
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
    
    func fetchAllInformationInBookmark() {
        let path = "/api/v1/bookmarks/information"
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseInformation>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserInformationBookmark = bookmark.data.information
                    jhPrint(currentUserVotesBookmark)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func deleteAllInformationsInbookmark(informationId: [Int], completion: @escaping () -> Void) {
        let path = "/api/v1/bookmarks/information"
        let body = ["informationBookmarkIds": informationId]
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "DELETE", path: path, body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success( _):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    currentUserInformationBookmark.removeAll { informationId.contains($0.informationBookmarkId) }
                    editBookmarkNumber.removeAll()

                    jhPrint("북마크 배열 삭제 성공")
                    completion()
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func updateInformationsInBookmark(informationId: Int) {
        let path = "/api/v1/bookmarks/information"
        let token = UserStore.shared.accessToken
        let body = [ "informationId" : informationId ]
        networkService.performRequest(method: "POST", path: path, body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    jhPrint("연관 컨텐츠를 북마크 추가 완료")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func deleteInformationsInBookmark(informationId: Int) {
        let path = "/api/v1/bookmarks/information/\(informationId)"
        let token = UserStore.shared.accessToken
        networkService.performRequest(method: "DELETE", path: path, body: nil, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    jhPrint("연관 컨텐츠를 북마크 삭제 완료")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchVotesInBookmarkWithCategoryId(categoryId: Int) {
        let path = "/api/v1/bookmarks/votes/categories/\(categoryId)"
        let token = UserStore.shared.accessToken
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseBookmark>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserVotesBookmark = bookmark.data.votes
                    jhPrint("카테고리에 맞는 북마크된 투표를 가져옴")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchInformationInBookmarkWithCategory(categoryId: Int) {
        let path = "/api/v1/bookmarks/information/categories/\(categoryId)"
        let token = UserStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseInformation>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserInformationBookmark = bookmark.data.information
                    jhPrint("카테고리에 맞는 북마크된 정보를 가져옴")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func updateEditBookmarkNumber(_ number: Int) {
        editBookmarkNumber.append(number)
        jhPrint(editBookmarkNumber)
    }
    
    func deleteEditBookmarkNumber(_ number: Int) {
        editBookmarkNumber = editBookmarkNumber.filter { $0 != number }
        jhPrint(editBookmarkNumber, isWarning: true)
    }
}
