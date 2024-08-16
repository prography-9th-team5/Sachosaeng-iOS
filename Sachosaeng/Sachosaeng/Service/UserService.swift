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
        
        NetworkService.shared.performRequest(method: "PUT", path: "/api/v1/users/user-type", body: body, token: token) { (result: Result<ResponseUser, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(_):
                    break
            }
        }
    }
    func updateUserNickname(_ userName: String) {
        let token = UserStore.shared.accessToken
        let body = ["nickname": userName]
        
        NetworkService.shared.performRequest(method: "PUT", path: "/api/v1/users/nickname", body: body, token: token) { (result: Result<ResponseUser, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(_):
                break
            }
        }
    }
    
    /// 유저 정보 가져오는건데요 ?
    func getUserInfo() {
        let token = UserStore.shared.accessToken
        
        NetworkService.shared.performRequest(method: "GET", path: "/api/v1/users", body: nil, token: token) {(result: Result<ResponseUser, NetworkError>) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    jhPrint(user.data.userType)
                    let nickname = user.data.nickname
                    let userId = user.data.userId
                    let userType = UserStore.shared.convertUserTypeForKorean(user.data.userType)
                    
                    UserStore.shared.currentUserState = User(userId: userId, nickname: nickname, userType: userType)
                }
            case .failure(let failure):
                jhPrint(failure)
            }
        }
    }
    
    /// 유저가 고른 카테고리를 갱신하는 메서드
    func updateUserCategory() {
        let token = UserStore.shared.accessToken
        let body = ["categoryIds": UserStore.shared.currentUserCategory]
        
        NetworkService.shared.performRequest(method: "PUT", path: "/api/v1/my-categories", body: body, token: token) { (result: Result<ResponseUser, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(_):
                break
            }
        }
    }
    
    /// 유저가 고른 카테고리들을 가져오는 메서드
    func getUserCategories() {
        let token = UserStore.shared.accessToken
        
        NetworkService.shared.performRequest(method: "GET", path: "/api/v1/my-categories", body: nil, token: token) {(result: Result<Response<[Category]>, NetworkError>) in
            switch result {
            case .success(let success):
                UserStore.shared.favoriteUserCategory = success.data
                jhPrint(UserStore.shared.favoriteUserCategory)
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
    
}
