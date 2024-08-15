//
//  UserStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import Foundation
import KakaoSDKAuth

final class UserStore: ObservableObject {
    static let shared = UserStore()
    
    @Published var oauthToken: OAuthToken?
    @Published var accessToken: String = ""
    @Published var refreshToken: String = ""
    @Published var userId: Int = 0
    @Published var currentUserEmail: String = ""
    @Published var currentUserCategory: [Int] = []
    @Published var favoriteUserCategory: [Category] = []
    @Published var currentUserState = User(userId: 0, nickname: "temp", userType: "학생")
    
    private init() {}
    
    func convertToUserType(_ type: String) {
        switch type {
        case "학생":
            currentUserState.userType = "STUDENT"
        case "취업준비생", "취준생":
            currentUserState.userType = "JOB_SEEKER"
        case "1~3년차 직장인":
            currentUserState.userType = "NEW_EMPLOYEE"
        case "기타":
            currentUserState.userType = "OTHER"
        case "STUDENT":
            currentUserState.userType = "학생"
        case "JOB_SEEKER":
            currentUserState.userType = "취업준비생"
        case "NEW_EMPLOYEE":
            currentUserState.userType = "1~3년차 직장인"
        case "OTHER":
            currentUserState.userType = "기타"
        default:
            currentUserState.userType = "이상한걸 쳐 집어넣었니"
        }
    }
    func convertUserTypeForKorean(_ type: String) -> String {
        switch type {
        case "STUDENT":
            return "학생"
        case "JOB_SEEKER":
            return "취업준비생"
        case "NEW_EMPLOYEE":
            return "1~3년차 직장인"
        case "OTHER":
            return "기타"
        default:
            return type
        }
    }
    
    func convertUserTypeForEnglish(_ type: String) -> String {
        switch type {
        case "학생":
            return "STUDENT"
        case "취업준비생":
            return "JOB_SEEKER"
        case "1~3년차 직장인":
            return "NEW_EMPLOYEE"
        case "기타":
            return "OTHER"
        default:
            return type
        }
    }
    func updateUserType(_ userType: String) {
        let token = UserStore.shared.accessToken
        let body = ["userType": userType]
        
        NetworkService.shared.performRequest(method: "PUT", path: "/api/v1/users/user-type", body: body, token: token) { (result: Result<ResponseUser, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(let failure):
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
        
        NetworkService.shared.performRequest(method: "GET", path: "/api/v1/users", body: nil, token: token) {[weak self] (result: Result<ResponseUser, NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }

                    jhPrint(user.data.userType)
                    let nickname = user.data.nickname
                    let userId = user.data.userId
                    let userType = convertUserTypeForKorean(user.data.userType)
                    
                    currentUserState = User(userId: userId, nickname: nickname, userType: userType)
                }
            case .failure(let failure):
                jhPrint(failure)
            }
        }
    }
    
    /// 유저가 고른 카테고리를 갱신하는 메서드
    func updateUserCategory() {
        let token = UserStore.shared.accessToken
        let body = ["categoryIds": currentUserCategory]
        
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
        
        NetworkService.shared.performRequest(method: "GET", path: "/api/v1/my-categories", body: nil, token: token) {[weak self] (result: Result<Response<[Category]>, NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let success):
                favoriteUserCategory = success.data
                jhPrint(favoriteUserCategory)
            case .failure(let failure):
                jhPrint(failure, isWarning: true)
            }
        }
    }
}
