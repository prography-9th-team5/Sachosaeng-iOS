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
                    // 한번 애플로긴으로 로그인 한 유저는 이메서드로 이메일을 받을 수 없음 이부분을 어떻게 할지 정해야하는데 흠 ,..
                    if let email = appleIDCredential.email {
                        UserStore.shared.currentUserEmail = email
                        jhPrint(email)
                        completion(true)
                    } else {
                        jhPrint("이야 왜이러노?")
                        completion(false)
                    }
                default:
                    jhPrint("낸들아니 시발")

                    completion(false)
            }
        case .failure(let failure):
            jhPrint(failure.localizedDescription)
            jhPrint("error")
            completion(false)
        }
    }
    
    func loginUser(completion: @escaping (Bool) -> Void) {
        authService.loginUser { success in
            completion(success)
        }
    }
    
    func registerUser(completion: @escaping (AuthTypeKeys) -> Void) {
        authService.joinUser { result in
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

