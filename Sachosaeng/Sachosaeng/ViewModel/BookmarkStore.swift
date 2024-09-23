//
//  BookmarkStore.swift
//  Sachosaeng
//
//  Created by LJh on 9/10/24.
//

import Foundation

final class BookmarkStore: ObservableObject {
    @Published var currentUserVotesBookmark: [Bookmark] = []
    @Published var currentUserInformationBookmark: [InformationInBookmark] = []
    @Published var currentUserCategoriesBookmark: [Category] = []
    @Published var currentUserInformationCategoriesBookmark: [Category] = []
    @Published var editBookmarkNumber: [Int] = []
    @Published var nextCursorForInformation: Int?
    @Published var selectedButton: BookmarkType = .vote
    @Published var isEditBookMark: Bool = false

    private let networkService = NetworkService.shared
    
    func fetchAllVotesBookmark() {
        let path = "/api/v1/bookmarks/votes"
        let token = UserInfoStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseBookmark>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserVotesBookmark = bookmark.data.votes
//                    jhPrint(currentUserVotesBookmark)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func deleteAllVotesBookmark(bookmarkId: [Int], completion: @escaping () -> Void) {
        jhPrint(bookmarkId)
        let path = "/api/v1/bookmarks/votes/delete"
        let body = ["voteBookmarkIds": bookmarkId]
        let token = UserInfoStore.shared.accessToken
        
        networkService.performRequest(method: "POST", path: path, body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success( _):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    currentUserVotesBookmark.removeAll { bookmarkId.contains( $0.voteBookmarkId) }
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
        let token = UserInfoStore.shared.accessToken
        
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
        let token = UserInfoStore.shared.accessToken
        
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
    
    func fetchAllInformationInBookmark(cursor: Int? = nil, size: Int = 10) {
        var path = "/api/v1/bookmarks/information?size=\(size)"
        if let cursor = cursor {
            path += "&cursor=\(cursor)"
        }
        
        let token = UserInfoStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseInformation>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserInformationBookmark = bookmark.data.information
                    if bookmark.data.hasNext {
                        nextCursorForInformation = bookmark.data.nextCursor
                    } else {
                        nextCursorForInformation = nil
                    }
//                    jhPrint(currentUserVotesBookmark)
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func deleteAllInformationsInbookmark(informationId: [Int], completion: @escaping () -> Void) {
        let path = "/api/v1/bookmarks/information/delete"
        let body = ["informationBookmarkIds": informationId]
        let token = UserInfoStore.shared.accessToken
        
        networkService.performRequest(method: "POST", path: path, body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
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
        let token = UserInfoStore.shared.accessToken
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
        let token = UserInfoStore.shared.accessToken
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
        let token = UserInfoStore.shared.accessToken
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
        let token = UserInfoStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseInformation>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserInformationBookmark = bookmark.data.information
                    jhPrint("카테고리에 맞는 연관컨텐츠 정보를 가져옴")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchCategoriesInbookmark() {
        let path = "/api/v1/bookmarks/vote-categories"
        let token = UserInfoStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseCategoriesData>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserCategoriesBookmark = bookmark.data.categories
                    if !currentUserCategoriesBookmark.isEmpty {
                        currentUserCategoriesBookmark.insert(Category(categoryId: 0, name: "ALL", iconUrl: "", backgroundColor: "#E4E7EC", textColor: ""), at: 0)
                    }
//                    jhPrint("사용자가 북마크한 투표들의 카테고리들만 조회합니다")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func fetchInformationCategoriesInbookmark() {
        let path = "/api/v1/bookmarks/information-categories"
        let token = UserInfoStore.shared.accessToken
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: token) { (result: Result<Response<ResponseCategoriesData>, NetworkError>) in
            switch result {
            case .success(let bookmark):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    currentUserInformationCategoriesBookmark = bookmark.data.categories
                    if !currentUserInformationCategoriesBookmark.isEmpty {
                        currentUserInformationCategoriesBookmark.insert(Category(categoryId: 0, name: "ALL", iconUrl: "", backgroundColor: "#E4E7EC", textColor: ""), at: 0)
                    }
//                    jhPrint("사용자가 북마크한 정보들의 카테고리들만 조회합니다")
                }
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
    func updateEditBookmarkNumber(_ number: Int) {
        if editBookmarkNumber.contains(number) {
            editBookmarkNumber.removeAll(where: { $0 == number })
        } else {
            editBookmarkNumber.append(number)
        }
//        jhPrint(editBookmarkNumber)
    }
    
//    func deleteEditBookmarkNumber(_ number: Int) {
//        editBookmarkNumber = editBookmarkNumber.filter { $0 != number }
//        jhPrint(editBookmarkNumber, isWarning: true)
//    }
}
