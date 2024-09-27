//
//  KakaoAuthService.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import AuthenticationServices
import GoogleSignIn

enum SignType: String {
    case apple = "애플"
    case kakao = "카카오"
    case google = "구글"
    case noSign = ""
}

final class SignStore: ObservableObject {
    private let authService = AuthService()
    
    func loginKakao(completion: @escaping (Bool) -> Void) {
        authService.loginKakao { success in
            UserDefaults.standard.setValue(UserInfoStore.shared.signType.rawValue, forKey: .signType)
            completion(success)
        }
    }
    
    func loginByTokenWithKakao() {
        authService.loginByTokenWithKakao { isSuccess in
            if isSuccess {
//                self.loginByToken()
            } else {
                jhPrint("카카오 자동로그인 안됩니다.")
            }
        }
    }
    func loginGoogle(completion: @escaping (Bool) -> Void) {
        authService.loginGoogle { success in
            UserDefaults.standard.set(UserInfoStore.shared.signType.rawValue, forKey: "SignType")
            completion(success)
        }
    }
    func loginApple(result: Result<ASAuthorization, Error>, completion: @escaping (Bool) -> Void) {
        authService.loginApple(result: result) { success in
            UserDefaults.standard.set(UserInfoStore.shared.signType.rawValue, forKey: "SignType")
            completion(success)
        }
    }
    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        authService.refreshAccessToken() { isSuccess in
            if isSuccess {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func loginUser(isApple: Bool = false, completion: @escaping (Bool) -> Void) {
        authService.loginUser(isApple: isApple) { success in
            completion(success)
        }
    }
    
    func registerUser(isApple: Bool = false, completion: @escaping (AuthTypeKeys) -> Void) {
        authService.registerUser(isApple: isApple) { result in
            completion(result)
        }
    }
    
    func withdrawUserAccount(_ reason: String) {
        authService.withdrawUserAccount(reason)
    }
    
    func logOut() {
        authService.logOutSachosaeng()
    }
}
