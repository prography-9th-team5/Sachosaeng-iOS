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
import Alamofire
import AuthenticationServices
import GoogleSignIn

enum AuthTypeKeys {
    case success
    case failed
    case userExists
}

final class SignStore: ObservableObject {
    private func handleOAuthToken(_ oauthToken: OAuthToken?) -> Bool {
        guard (oauthToken?.idToken) != nil else {
            jhPrint("oauthToken 받아오기 실패")
            return false
        }
        return true
    }
    
    private func handleLoginError(_ error: Error) {
        jhPrint(error.localizedDescription)
    }
    
    func loginKakao(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk { type in
                completion(type)
            }
//            UserApi.shared.accessTokenInfo { [weak self] (_, error) in
//                guard let self = self else { return }
//                if let error = error, let sdkError = error as? SdkError, sdkError.isInvalidTokenError() {
//                    loginWithKakaoTalk { type in
//                        completion(type)
//                    }
//                } else if let error = error {
//                    handleLoginError(error)
//                } else {
//                    // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
//                }
//            }
        } else {
            loginWithKakaoAccount { type in
                completion(type)
            }
        }
    }
    
    func loginWithKakaoTalk(completion: @escaping (Bool) -> Void) {
        UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
            guard let self = self else { return }
            if let error = error {
                handleLoginError(error)
            } else {
                UserStore.shared.oauthToken = oauthToken
                if handleOAuthToken(UserStore.shared.oauthToken) {
                    getKakaoUser { type in
                        completion(type)
                    }
                }
            }
        }
    }
    
    func loginWithKakaoAccount(completion: @escaping (Bool) -> Void) {
        UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
            guard let self = self else { return }
            if let error = error {
                handleLoginError(error)
            } else {
                UserStore.shared.oauthToken = oauthToken
                if handleOAuthToken(UserStore.shared.oauthToken) {
                    getKakaoUser { type in
                        completion(type)
                    }
                }
            }
        }
    }
    
    /// 유저 데이터 가져오기
    func getKakaoUser(completion: @escaping (Bool) -> Void) {
        UserApi.shared.me { user, error in
            if let error = error {
                jhPrint("유저 데이터를 가져오는 데 실패했습니다. \(error.localizedDescription)", isWarning: true)
                completion(false)
            } else if let email = user?.kakaoAccount?.email {
                UserStore.shared.currentUserEmail = email
                jhPrint("유저 데이터 가져오기 성공: \(email)")
                completion(true)
            } else {
                jhPrint("이메일을 찾을 수 없습니다.", isWarning: true)
                completion(false)
            }
        }
    }
    
    /// 카카오톡 회원탈퇴 시키기
    func withdrawOfKakaoTalk() {
        UserApi.shared.unlink {(error) in
            if error != nil {
                jhPrint(error!.localizedDescription, isWarning: true)
            } else {
                jhPrint("kakaoUnLink success.")
            }
        }
    }
    
    /// 구글로그인
    func loginGoogle(completion: @escaping (Bool) -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            completion(false)
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                jhPrint("Google Sign-In Error: \(error.localizedDescription)", isWarning: true)
                completion(false)
            } else if let signInResult = signInResult {
                UserStore.shared.currentUserEmail = signInResult.user.profile?.email ?? ""
                jhPrint("Google Sign-In Success: \(signInResult.user.profile?.email ?? "No Name")")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    /// api 중 사초생 로그인
    func authLogin(completion: @escaping (Bool) -> Void) {
        let body = ["email": UserStore.shared.currentUserEmail]
        
        NetworkService.shared.performRequest(method: "POST", path: "/api/v1/auth/login", body: body, token: nil) { (response: AuthResponse?, error) in
            if let error = error {
                jhPrint("Error: \(error.localizedDescription)", isWarning: true)
                completion(false)
            } else if let response = response {
                UserStore.shared.accessToken = response.data.accessToken
                UserStore.shared.refreshToken = response.data.refreshToken
                UserStore.shared.userId = response.data.userId
                jhPrint("""
                        ⭐️ Access Token: \(UserStore.shared.accessToken)
                        ⭐️ Refresh Token: \(UserStore.shared.refreshToken)
                        """)
                completion(true)
            }
        }
    }
    
    /// api 중 사초생 탈퇴
    func authWithDraw() {
        let token = UserStore.shared.accessToken
        jhPrint("Access Token: \(token)", isWarning: true)
        let body = ["reason": "hi"]
        
        NetworkService.shared.performRequest(method: "DELETE", path: "/api/v1/auth/withdraw", body: body, token: token) { authType in
            switch authType {
            case .success(let json):
               return jhPrint(json)
            case .failed(let error):
                return jhPrint(error)
            case .userExists(_):
                return jhPrint("치명적이야")
            }
        }
    }
    /// api 중 사초생 회원가입
    func authJoin(completion: @escaping (AuthTypeKeys) -> Void) {
        let body = ["email": UserStore.shared.currentUserEmail]
        
        NetworkService.shared.performRequest(method: "POST", path: "/api/v1/auth/join", body: body, token: nil) { authType in
            switch authType {
            case .success(let json):
                jhPrint(json)
                completion(.success)
            case .failed(let error):
                jhPrint(error)
                completion(.failed)
            case .userExists(_):
            jhPrint("이미 가입한 유저입니다")
            completion(.userExists)
            }
        }
    }
}
