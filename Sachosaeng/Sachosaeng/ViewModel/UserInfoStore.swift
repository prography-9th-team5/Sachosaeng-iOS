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
    @Published var userId: Int = 0
    @Published var currentUserCategories: [Category] = []
    @Published var currentUserState = User(userId: 0, nickname: "랜덤이름", userType: "학생")
    @Published var selectedCategoriesInSignFlow: [Category] = []
    let deviceInfo = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    func getDeviceModelName() -> String {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        switch (screenWidth, screenHeight) {
        case (320, 480):
            return "iPhone 3GS"
        case (320, 480):
            return "iPhone 4 or iPhone 4s"
        case (320, 568):
            return "iPhone 5, iPhone 5c, iPhone 5s, or iPhone SE (1st Gen)"
        case (375, 667):
            return "iPhone 6, iPhone 6s, iPhone 7, iPhone 8, iPhone SE (2nd Gen)"
        case (375, 812):
            return "iPhone 12 mini, iPhone 13 mini"
        case (414, 736):
            return "iPhone 6 Plus, iPhone 6s Plus, iPhone 7 Plus, iPhone 8 Plus"
        case (375, 812):
            return "iPhone X, iPhone XS, iPhone 11 Pro"
        case (414, 896):
            return "iPhone XR, iPhone 11"
        case (390, 844):
            return "iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14"
        case (393, 852):
            return "iPhone 14 Pro"
        case (414, 896):
            return "iPhone XS Max, iPhone 11 Pro Max"
        case (428, 926):
            return "iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus"
        case (430, 932):
            return "iPhone 14 Pro Max"
        case (1024, 768):
            return "iPad, iPad Mini"
        case (1112, 834):
            return "iPad Pro 10.5 inch, iPad Air"
        case (1194, 834):
            return "iPad Pro 11 inch"
        case (1366, 1024):
            return "iPad Pro 12.9 inch"
        default:
            return "Unknown"
        }
    }
    
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
    }
    func resetUserInfoStore() {
        userId = 0
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
