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
    // OAuthToken 처리
    private func handleOAuthToken(_ oauthToken: OAuthToken?) -> Bool {
        guard (oauthToken?.idToken) != nil else {
            jhPrint("oauthToken 받아오기 실패")
            return false
        }
        return true
    }
    
    // 로그인 에러 처리
    private func handleLoginError(_ error: Error) {
        jhPrint(error.localizedDescription)
    }
    
    // 카카오 로그인
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
    
    // 카카오톡으로 로그인
    private func loginWithKakaoTalk(completion: @escaping (Bool) -> Void) {
        UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
            guard let self = self else { return }
            if let error = error {
                self.handleLoginError(error)
            } else {
                UserInfoStore.shared.oauthToken = oauthToken
                if self.handleOAuthToken(UserInfoStore.shared.oauthToken) {
                    self.getKakaoUser { type in
                        completion(type)
                    }
                }
            }
        }
    }
    
    // 카카오 계정으로 로그인
    private func loginWithKakaoAccount(completion: @escaping (Bool) -> Void) {
        UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
            guard let self = self else { return }
            if let error = error {
                self.handleLoginError(error)
            } else {
                UserInfoStore.shared.oauthToken = oauthToken
                if self.handleOAuthToken(UserInfoStore.shared.oauthToken) {
                    self.getKakaoUser { type in
                        completion(type)
                    }
                }
            }
        }
    }
    
    // 카카오 사용자 정보 가져오기
    private func getKakaoUser(completion: @escaping (Bool) -> Void) {
        UserApi.shared.me { user, error in
            if let error = error {
                jhPrint("유저 데이터를 가져오는 데 실패했습니다. \(error.localizedDescription)", isWarning: true)
                completion(false)
            } else if let email = user?.kakaoAccount?.email {
                UserInfoStore.shared.signType = .kakao
                UserInfoStore.shared.currentUserEmail = email
                jhPrint("유저 데이터 가져오기 성공: \(email)")
                completion(true)
            } else {
                jhPrint("이메일을 찾을 수 없습니다.", isWarning: true)
                completion(false)
            }
        }
    }
    
    // 카카오톡 회원 탈퇴
    func withdrawOfKakaoTalk() {
        UserApi.shared.unlink { error in
            if let error = error {
                jhPrint(error.localizedDescription, isWarning: true)
            } else {
                jhPrint("kakaoUnLink success.")
            }
        }
    }
    
    // 구글 로그인
    func loginGoogle(completion: @escaping (Bool) -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.rootViewController else {
                completion(false)
                return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                jhPrint("Google Sign-In Error: \(error.localizedDescription)", isWarning: true)
                completion(false)
            } else if let signInResult = signInResult {
                UserInfoStore.shared.signType = .google
                UserInfoStore.shared.currentUserEmail = signInResult.user.profile?.email ?? ""
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // 사용자 로그인
    func loginUser(isApple: Bool = false, completion: @escaping (Bool) -> Void) {
        let body = ["email": UserInfoStore.shared.currentUserEmail]
        let path = isApple ? "/api/v1/auth/login?type=APPLE" : "/api/v1/auth/login"
        
        NetworkService.shared.performRequest(method: "POST", path: path, body: body, token: nil) { (result: Result<AuthResponse, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    UserInfoStore.shared.accessToken = response.data.accessToken
                    UserInfoStore.shared.refreshToken = response.data.refreshToken
                    UserInfoStore.shared.userId = response.data.userId
                    completion(true)
                }
            case .failure(let error):
                jhPrint("Error: \(error.localizedDescription)", isWarning: true)
                completion(false)
            }
        }
    }
    
    // 사용자 계정 탈퇴
    func withdrawUserAccount() {
        switch UserInfoStore.shared.signType {
        case .apple:
            break
        case .kakao:
            withdrawOfKakaoTalk()
        case .google:
            break
        case .none:
            break
        }
        
        let token = UserInfoStore.shared.accessToken
        jhPrint("Access Token: \(token)", isWarning: true)
        let body = ["reason": "hi"]
        
        NetworkService.shared.performRequest(method: "DELETE", path: "/api/v1/auth/withdraw", body: body, token: token) { (result: Result<AuthResponse, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    UserInfoStore.shared.accessToken = ""
                    jhPrint("탈퇴 성공: \(response) UserStore.shared.accessToken: \(UserInfoStore.shared.accessToken)")
                }
            case .failure(let error):
                jhPrint("탈퇴 실패: \(error)")
            }
        }
    }
    
    // 사용자 회원가입
    func registerUser(isApple: Bool = false, completion: @escaping (AuthTypeKeys) -> Void) {
        let body = [
            "email": UserInfoStore.shared.currentUserEmail,
            "userType": "STUDENT"
        ]
        let path = isApple ? "/api/v1/auth/join?type=APPLE" : "/api/v1/auth/join"
        
        NetworkService.shared.performRequest(method: "POST", path: path, body: body, token: nil) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success( _):
                completion(.success)
            case .failure(let error):
                if case .userExists = error {
                    completion(.userExists)
                } else {
                    completion(.failed)
                }
            }
        }
    }
}
