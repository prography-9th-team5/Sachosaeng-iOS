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

final class SignStore: ObservableObject {
    private let authService = AuthService()
    
    func loginKakao(completion: @escaping (Bool) -> Void) {
        authService.loginKakao { success in
            completion(success)
        }
    }
    
    func loginGoogle(completion: @escaping (Bool) -> Void) {
        authService.loginGoogle { success in
            completion(success)
        }
    }
    
    func loginUser(completion: @escaping (Bool) -> Void) {
        authService.loginUser { success in
            completion(success)
        }
    }
    
    func registerUser(completion: @escaping (AuthTypeKeys) -> Void) {
        authService.registerUser { result in
            completion(result)
        }
    }
    
    func withdrawUserAccount() {
        authService.withdrawUserAccount()
    }
    
    func withdrawOfKakaoTalk() {
        authService.withdrawOfKakaoTalk()
    }
}

