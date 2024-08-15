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
    @Published var currentUserState = User(userId: 0, nickname: "temp", userType: "학생")
    
    func convertTypeForEnglish(_ type: String) {
        switch type {
        case "학생":
            currentUserState.userType = "STUDENT"
        case "취업준비생":
            currentUserState.userType = "JOB_SEEKER"
        case "1~3년차 직장인":
            currentUserState.userType = "NEW_EMPLOYEE"
        case "기타":
            currentUserState.userType = "OTHER"
        default:
            currentUserState.userType = "이상한걸 쳐 집어넣었니"
        }
    }
    
    private init() {}
    
    func updateUserType(_ userType: String) {
        let token = UserStore.shared.accessToken
        let body = ["userType": userType]
        
        NetworkService.shared.performRequest(method: "PUT", path: "/api/v1/users/user-type", body: body, token: token) { (result: Result<ResponseUser, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(let failure):
                jhPrint(failure)
            }
        }
    }
    
    func getUserInfo() {
        let token = UserStore.shared.accessToken
        
        NetworkService.shared.performRequest(method: "GET", path: "/api/v1/users", body: nil, token: token) { (result: Result<ResponseUser, NetworkError>) in
            switch result {
            case .success(let success):
                jhPrint(success)
            case .failure(let failure):
                jhPrint(failure)
            }
        }
    }
}
