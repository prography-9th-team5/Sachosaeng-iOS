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
    @Published var currentUserCategories: [Category] = []
    @Published var currentUserState = User(userId: 0, nickname: "temp", userType: "학생")
    @Published var selectedCategoriesInSignFlow: [Category] = []
    
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
}
