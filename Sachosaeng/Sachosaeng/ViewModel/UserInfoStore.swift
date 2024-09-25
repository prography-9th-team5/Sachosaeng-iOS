//
//  UserStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import Foundation
import KakaoSDKAuth
import UIKit

final class UserInfoStore: ObservableObject {
    static let shared = UserInfoStore()
    
    @Published var signType: SignType = .noSign
    @Published var oauthToken: OAuthToken?
    @Published var accessToken: String = ""
    @Published var refreshToken: String = ""
    @Published var userId: Int = 0
    @Published var currentUserEmail: String = ""
    @Published var currentUserCategories: [Category] = []
    @Published var currentUserState = User(userId: 0, nickname: "랜덤이름", userType: "학생")
    @Published var selectedCategoriesInSignFlow: [Category] = []
    let deviceInfo = UIDevice.current.identifierForVendor?.uuidString ?? ""
    private init() {}
    func performSetSignType() {
        guard let UserdefaultsSignType = UserDefaults.standard.string(forKey: "SignType") else { return }
        switch UserdefaultsSignType {
            case "애플":
                UserInfoStore.shared.signType = .apple
            case "구글":
                UserInfoStore.shared.signType = .google
            case "카카오":
                UserInfoStore.shared.signType = .kakao
            case "":
                UserInfoStore.shared.signType = .noSign
            default:
                UserInfoStore.shared.signType = .noSign
        }
        jhPrint(UserDefaults.standard.string(forKey: "SignType") as Any)
        jhPrint(UserInfoStore.shared.signType)
    }
    func resetUserInfo() {
        oauthToken = nil
        accessToken = ""
        refreshToken = ""
        userId = 0
        currentUserEmail = ""
        currentUserCategories = []
        currentUserState = User(userId: 0, nickname: "temp", userType: "학생")
        selectedCategoriesInSignFlow = []
    }
    
    func convertToUserType(_ type: String, completion: @escaping () -> ()) {
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
