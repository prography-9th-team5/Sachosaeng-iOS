//
//  UserService.swift
//  Sachosaeng
//
//  Created by LJh on 8/16/24.
//

import Foundation

final class UserService: ObservableObject {
    static let shared = UserService()
    private init() {}
    
    func updateUserType(_ userType: String) {
        let token = UserStore.shared.accessToken
        let body = ["userType": userType]
        
        NetworkService.shared.performRequest(method: "PUT", path: "/api/v1/users/user-type", body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(let err):
                jhPrint(err)
            }
        }
    }
    /// 사초생 API 메서드: 닉네임 갱신
    func updateUserNickname(_ userName: String) {
        let token = UserStore.shared.accessToken
        let body = ["nickname": userName]
        
        NetworkService.shared.performRequest(method: "PUT", path: "/api/v1/users/nickname", body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(let err):
                jhPrint(err)
            }
        }
    }
    
    /// 유저 정보 가져오는건데요 ?
    func getUserInfo() {
        let token = UserStore.shared.accessToken
        
        NetworkService.shared.performRequest(method: "GET", path: "/api/v1/users", body: nil, token: token) {(result: Result<Response<User>, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    jhPrint(user.data.userType)
                    let nickname = user.data.nickname
                    let userId = user.data.userId
                    let userType = UserStore.shared.convertUserTypeForKorean(user.data.userType)
                    
                    UserStore.shared.currentUserState = User(userId: userId, nickname: nickname, userType: userType)
                    
                case .failure(let failure):
                    jhPrint(failure)
                }
            }
        }
    }
    
    /// 유저가 고른 카테고리를 갱신하는 메서드
    func updateUserCategory(_ categories: [Category]) {
        let token = UserStore.shared.accessToken
        let categoryIds = categories.map { $0.id }
        let body = ["categoryIds": categoryIds]

        NetworkService.shared.performRequest(method: "PUT", path: "/api/v1/my-categories", body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(let error):
                jhPrint(error, isWarning: true)
            }
        }
    }
    
    /// 유저가 고른 카테고리들을 가져오는 메서드
    func getUserCategories() {
        let token = UserStore.shared.accessToken
        NetworkService.shared.performRequest(method: "GET", path: "/api/v1/my-categories", body: nil, token: token) {(result: Result<Response<ResponseCategoriesData>, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    UserStore.shared.currentUserCategories = success.data.categories
                case .failure(let failure):
                    jhPrint("getUserCategories \(failure)", isWarning: true)
                }
            }
        }
    }
}
