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
        jhPrint("oauthToken: \(String(describing: oauthToken))")
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
    /// 카카오 자동로그인
    func loginByTokenWithKakao(completion: @escaping (Bool) -> Void) {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        jhPrint("로그인이 필요합니다.")
                        completion(false)
                    }
                    else {
                        completion(false)
                        jhPrint(error.localizedDescription)
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    completion(true)
//                    jhPrint("토큰 있따")
                }
            }
        }
        else {
            completion(false)
            jhPrint("카카오로 로그인을 하지 않았었습니다.")
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
    // 카카오 웹으로 로그인
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
//                UserDefaults.standard.set(UserInfoStore.shared.signType, forKey: "SignType")
                UserInfoStore.shared.currentUserEmail = email
                jhPrint("유저 데이터 가져오기 성공: \(email)")
                completion(true)
            } else {
                jhPrint("이메일을 찾을 수 없습니다.", isWarning: true)
                completion(false)
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
//                UserDefaults.standard.set(UserInfoStore.shared.signType, forKey: "SignType")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    // 애플 로그인
    func loginApple(result: Result<ASAuthorization, Error>, completion: @escaping (Bool) -> Void) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    UserInfoStore.shared.signType = .apple
//                    UserDefaults.standard.set(UserInfoStore.shared.signType, forKey: "SignType")
                    jhPrint(appleIDCredential.authorizationCode)
                    UserInfoStore.shared.currentUserEmail = appleIDCredential.user
                    completion(true)
                default:
                    jhPrint("안됩니다.", isWarning: true)
            }
        case .failure(let failure):
            jhPrint(failure.localizedDescription)
            jhPrint("error")
                completion(false)
        }
    }
    /// 토큰 재발급
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard UserDefaults.standard.string(forKey: "SachoSaengAccessToken") != nil else {
            jhPrint("Access token이 없습니다.", isWarning: true)
            return completion(false)
        }
        guard let refreshToken = UserDefaults.standard.string(forKey: "SachoSaengRefreshToken") else {
            jhPrint("Refresh token이 없습니다.", isWarning: true)
            return completion(false)
        }
//        guard let signType = UserDefaults.standard.string(forKey: "SignType") else {
//            jhPrint("사인타입이 없음")
//            return completion(false)
//        }
        
        let path = "/api/v1/auth/refresh"
        let headers = [
           "Cookie": "Refresh=\(refreshToken)",
            "X-Device": UserInfoStore.shared.deviceInfo
        ]
//        jhPrint("여기")
        NetworkService.shared.performRequest(method: "POST", path: path, body: nil, token: nil, headers: headers) { (result: Result<Response<RefreshData>, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    UserInfoStore.shared.accessToken = response.data.accessToken
                    UserInfoStore.shared.refreshToken = response.data.refreshToken
                    UserDefaults.standard.set(response.data.accessToken, forKey: "SachoSaengAccessToken")
                    UserDefaults.standard.set(response.data.refreshToken, forKey: "SachoSaengRefreshToken")
                    jhPrint("token: \(response.data.accessToken)", isWarning: true)
                    jhPrint("userdefaultstoken: \(String(describing: UserDefaults.standard.string(forKey: "SachoSaengAccessToken")))", isWarning: true)
//                    jhPrint("사인타입: \(signType)", isWarning: true)
                    completion(true)
                }
            case .failure(let error):
                jhPrint("Error: \(error.localizedDescription)", isWarning: true)
                completion(false)
            }
        }
    }
    /// 사용자 로그인
    func loginUser(isApple: Bool = false, completion: @escaping (Bool) -> Void) {
        let body = ["email": UserInfoStore.shared.currentUserEmail]
        let path = isApple ? "/api/v1/auth/login?type=APPLE" : "/api/v1/auth/login"
        let header = ["X-Device" : UserInfoStore.shared.deviceInfo]
        
        NetworkService.shared.performRequest(method: "POST", path: path, body: body, token: nil, headers: header) { (result: Result<AuthResponse, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    UserInfoStore.shared.accessToken = response.data.accessToken
                    UserInfoStore.shared.refreshToken = response.data.refreshToken
                    UserInfoStore.shared.userId = response.data.userId
                    UserDefaults.standard.set(response.data.accessToken, forKey: "SachoSaengAccessToken")
                    UserDefaults.standard.set(response.data.refreshToken, forKey: "SachoSaengRefreshToken")
//                    UserDefaults.standard.set(UserInfoStore.shared.signType.rawValue, forKey: "SignType")
//                    jhPrint("token: \(response.data.accessToken)", isWarning: true)
//                    jhPrint("userdefaultstoken: \(String(describing: UserDefaults.standard.string(forKey: "SachoSaengAccessToken")))", isWarning: true)
                    completion(true)
                }
            case .failure(let error):
                jhPrint("Error: \(error.localizedDescription)", isWarning: true)
                completion(false)
            }
        }
    }
    /// 토큰으로 로그인
//    func loginByToken() {
//        guard let token = UserDefaults.standard.string(forKey: "SachoSaengAccessToken") else {
//            jhPrint("Access token이 없습니다.", isWarning: true)
//            return
//        }
//        
//        let body = ["loginToken": token]
//        let path = "/api/v1/auth/login-by-token"
//        let header = ["X-Device" : UserInfoStore.shared.deviceInfo]
//        NetworkService.shared.performRequest(method: "POST", path: path, body: body, token: nil, headers: header) { (result: Result<AuthResponse, NetworkError>) in
////            jhPrint(result, isWarning: true)
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    UserInfoStore.shared.accessToken = response.data.accessToken
//                    UserInfoStore.shared.refreshToken = response.data.refreshToken
//                    UserInfoStore.shared.userId = response.data.userId
//                    UserDefaults.standard.set(response.data.accessToken, forKey: "SachoSaengAccessToken")
//                    UserDefaults.standard.set(response.data.refreshToken, forKey: "SachoSaengRefreshToken")
//                }
//            case .failure(let err):
//                jhPrint(err.localizedDescription)
//                jhPrint("userdefaultstoken: \(String(describing: UserDefaults.standard.string(forKey: "SachoSaengAccessToken")))", isWarning: true)
//            }
//        }
//    }
    /// 사용자 회원탈퇴
    func withdrawUserAccount(_ reason: String) {
        switch UserInfoStore.shared.signType {
        case .apple:
            break
        case .kakao:
            UserApi.shared.unlink { error in
                if let error = error {
                    jhPrint(error.localizedDescription, isWarning: true)
                } else {
                    jhPrint("kakaoUnLink success.")
                }
            }
        case .google:
            GIDSignIn.sharedInstance.disconnect()
        case .noSign:
            break
        }
        
        let token = UserInfoStore.shared.accessToken
        let body = ["reason": reason]
        
        NetworkService.shared.performRequest(method: "POST", path: "/api/v1/auth/withdraw", body: body, token: token) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    UserInfoStore.shared.resetUserInfo()
                    jhPrint("탈퇴 성공: \(response) UserStore.shared.accessToken: \(UserInfoStore.shared.accessToken)")

                }
            case .failure(let error):
                jhPrint("탈퇴 실패: \(error) UserStore.shared.accessToken: \(UserInfoStore.shared.accessToken)")
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
    /// 사용자 로그아웃
    func logOutSachosaeng() {
        switch UserInfoStore.shared.signType {
        case .apple:
            break
        case .kakao:
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success.")
                }
            }
        case .google:
            GIDSignIn.sharedInstance.signOut()
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, err in
                if err != nil || user == nil {
                    jhPrint("로그아웃 상태입니다.")
                } else {
                    jhPrint("로그인 상태입니다.: \(user?.profile?.email as Any)")
                }
            }
        case .noSign:
            break
        }
        UserInfoStore.shared.resetUserInfo()
        UserDefaults.standard.removeObject(forKey: "SachoSaengAccessToken")
        UserDefaults.standard.removeObject(forKey: "SachoSaengRefreshToken")
        UserDefaults.standard.removeObject(forKey: "SignType")
    }
    
    func revoteAppleToken() {
        
    }
}
