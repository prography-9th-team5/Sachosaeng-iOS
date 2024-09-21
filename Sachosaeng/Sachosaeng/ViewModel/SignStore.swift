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
    
    func loginApple(result: Result<ASAuthorization, Error>, completion: @escaping (Bool) -> Void) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    UserInfoStore.shared.currentUserEmail = appleIDCredential.user
                    jhPrint(appleIDCredential.user)
                    completion(true)
                default:
                    jhPrint("안됩니다.", isWarning: true)
                    completion(false)
            }
        case .failure(let failure):
            jhPrint(failure.localizedDescription)
            jhPrint("error")
            completion(false)
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
    
    func withdrawUserAccount() {
        authService.withdrawUserAccount()
    }
    
    func withdrawOfKakaoTalk() {
        authService.withdrawOfKakaoTalk()
    }
}

