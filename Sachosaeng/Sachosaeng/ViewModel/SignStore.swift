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

enum SignType {
    case apple
    case kakao
    case google
}

final class SignStore: ObservableObject {
    private let authService = AuthService()
    let bundle = Bundle.main.bundleIdentifier!
    let appleTeamID = Bundle.main.object(forInfoDictionaryKey: "Apple_Team_Id") as? String

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
    
//    func revokeAppleToken(clientSecret: String, token: String, completionHandler: @escaping () -> Void) {
//            let url = "https://appleid.apple.com/auth/revoke?client_id=com.Prography.Sachosaeng&client_secret=\(clientSecret)&token=\(token)&token_type_hint=refresh_token"
//            let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
//
//            AF.request(url,
//                       method: .post,
//                       headers: header)
//            .validate(statusCode: 200..<600)
//            .responseData { response in
//                guard let statusCode = response.response?.statusCode else { return }
//                if statusCode == 200 {
//                    print("애플 토큰 삭제 성공!")
//                    completionHandler()
//                }
//            }
//        }
    
    func loginApple(result: Result<ASAuthorization, Error>, completion: @escaping (Bool) -> Void) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    UserInfoStore.shared.signType = .apple
                    UserInfoStore.shared.currentUserEmail = appleIDCredential.user
                default:
                    jhPrint("안됩니다.", isWarning: true)
            }
        case .failure(let failure):
            jhPrint(failure.localizedDescription)
            jhPrint("error")
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
    
    func withdrawOfKakaoTalk() {
        authService.withdrawOfKakaoTalk()
    }
}

