//
//  AuthService.swift
//  Sachosaeng
//
//  Created by LJh on 8/16/24.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import AuthenticationServices
import GoogleSignIn

enum AuthTypeKeys {
    case success
    case failed
    case userExists
}

final class AuthService {
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
        } else {
            loginWithKakaoAccount { type in
                completion(type)
            }
        }
    }
    
    private func loginWithKakaoTalk(completion: @escaping (Bool) -> Void) {
        UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
            guard let self = self else { return }
            if let error = error {
                self.handleLoginError(error)
            } else {
                UserStore.shared.oauthToken = oauthToken
                if self.handleOAuthToken(UserStore.shared.oauthToken) {
                    self.getKakaoUser { type in
                        completion(type)
                    }
                }
            }
        }
    }
    
    private func loginWithKakaoAccount(completion: @escaping (Bool) -> Void) {
        UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
            guard let self = self else { return }
            if let error = error {
                self.handleLoginError(error)
            } else {
                UserStore.shared.oauthToken = oauthToken
                if self.handleOAuthToken(UserStore.shared.oauthToken) {
                    self.getKakaoUser { type in
                        completion(type)
                    }
                }
            }
        }
    }
    
    private func getKakaoUser(completion: @escaping (Bool) -> Void) {
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
    
    func withdrawOfKakaoTalk() {
        UserApi.shared.unlink { error in
            if let error = error {
                jhPrint(error.localizedDescription, isWarning: true)
            } else {
                jhPrint("kakaoUnLink success.")
            }
        }
    }
    
    
    
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
    
    func loginUser(completion: @escaping (Bool) -> Void) {
        let body = ["email": UserStore.shared.currentUserEmail]
        
        NetworkService.shared.performRequest(method: "POST", path: "/api/v1/auth/login", body: body, token: nil) { (result: Result<AuthResponse, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    UserStore.shared.accessToken = response.data.accessToken
                    UserStore.shared.refreshToken = response.data.refreshToken
                    UserStore.shared.userId = response.data.userId
                    jhPrint("""
                    ⭐️ Access Token: \(UserStore.shared.accessToken)
                    ⭐️ Refresh Token: \(UserStore.shared.refreshToken)
                    """)
                    completion(true)
                }
            case .failure(let error):
                jhPrint("Error: \(error.localizedDescription)", isWarning: true)
                completion(false)
            }
        }
    }
    
    func withdrawUserAccount() {
        let token = UserStore.shared.accessToken
        jhPrint("Access Token: \(token)", isWarning: true)
        let body = ["reason": "hi"]
        
        NetworkService.shared.performRequest(method: "DELETE", path: "/api/v1/auth/withdraw", body: body, token: token) { (result: Result<AuthResponse, NetworkError>) in
            switch result {
            case .success(let response):
                jhPrint("탈퇴 성공: \(response)")
            case .failure(let error):
                jhPrint("탈퇴 실패: \(error)")
            }
        }
    }
    
    func joinUser(completion: @escaping (AuthTypeKeys) -> Void) {
        let body = [
            "email": UserStore.shared.currentUserEmail,
            "userType": "STUDENT"
            ]
        
        NetworkService.shared.performRequest(method: "POST", path: "/api/v1/auth/join", body: body, token: nil) { (result: Result<AuthResponse, NetworkError>) in
            switch result {
            case .success(let response):
                jhPrint("회원가입 성공: \(response)")
                completion(.success)
            case .failure(let error):
                if case .userExists = error {
                    jhPrint("이미 가입한 유저입니다")
                    completion(.userExists)
                } else {
                    jhPrint("회원가입 실패: \(error)")
                    completion(.failed)
                }
            }
        }
    }
}
