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
import Alamofire

enum AuthTypeKeys {
    case success
    case failed
    case userExists
}

final class AuthService {
    private let bundle = Bundle.main.bundleIdentifier!
    private let appleTeamID = Bundle.main.object(forInfoDictionaryKey: "Apple_Team_Id") as? String
    private var token = KeychainService.shared.getSachoSaengAccessToken()
    // MARK: - 카카오
    
    // OAuthToken 처리
    private func handleOAuthToken(_ oauthToken: OAuthToken?) -> Bool {
        guard let oauthToken = oauthToken else {
            jhPrint("oauthToken 받아오기 실패")
            return false
        }
        
        do {
            let tokenData = try JSONEncoder().encode(oauthToken)
            
            if KeychainService.shared.save(key: .oauthToken, data: tokenData) {
                jhPrint("oauthToken 키체인에 저장 완료")
                return true
            } else {
                jhPrint("oauthToken 키체인에 저장 실패")
                return false
            }
        } catch {
            jhPrint("oauthToken을 데이터로 변환하는데 실패: \(error.localizedDescription)")
            return false
        }
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
                if self.handleOAuthToken(oauthToken) {
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
                if self.handleOAuthToken(oauthToken) {
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
                if let emailData = email.data(using: .utf8) {
                    if KeychainService.shared.save(key: .userEmail, data: emailData) {
                        jhPrint("이메일 저장 성공")
                        completion(true)
                    } else {
                        jhPrint("이메일 저장실패")
                        completion(false)
                    }
                } else {
                    jhPrint("이메일 변환 실패 ")
                }
            } else {
                jhPrint("이메일을 찾을 수 없습니다.", isWarning: true)
                completion(false)
            }
        }
    }
    /// 카카오 토큰체크
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
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    completion(true)
                }
            }
        }
        else {
            completion(false)
            jhPrint("카카오로 로그인을 하지 않았었습니다.")
        }
    }
    // MARK: - 구글
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
            } else if let signInResult = signInResult, let email = signInResult.user.profile?.email {
                UserInfoStore.shared.signType = .google
                
                if let emailData = email.data(using: .utf8) {
                    if KeychainService.shared.save(key: .userEmail, data: emailData) {
                        jhPrint("이메일 저장 성공")
                        completion(true)
                    } else {
                        jhPrint("이메일 저장 실패", isWarning: true)
                        completion(false)
                    }
                } else {
                    jhPrint("이메일 데이터 변환 실패", isWarning: true)
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    // MARK: - 애플
    // 애플 로그인 키체인으로 변경완료
    func loginApple(result: Result<ASAuthorization, Error>, completion: @escaping (Bool) -> Void) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    if  let authorizationCode = appleIDCredential.authorizationCode,
                        let identityToken = appleIDCredential.identityToken,
                        let authCodeString = String(data: authorizationCode, encoding: .utf8),
                        let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                        jhPrint("""
                                "authorizationCode: \(authorizationCode)
                                identityToken: \(identityToken)
                                authCodeString: \(authCodeString)
                                identifyTokenString: \(identifyTokenString)
                                """)
                        if KeychainService.shared.save(key: .appleAccessToken, data: authorizationCode) {
                            jhPrint("애플토큰 키체인에 등록 완료")
                        } else {
                            jhPrint("애플토큰 키체인에 등록 실패 ")
                        }
                        if KeychainService.shared.save(key: .appleUserID, data: appleIDCredential.user.data(using: .utf8)!) {
                            jhPrint("애플유저아이디 키체인에 등록 완료")
                        } else {
                            jhPrint("애플토큰 키체인에 등록 실패")
                        }
                        if KeychainService.shared.save(key: .userEmail, data: appleIDCredential.user.data(using: .utf8)!) {
                            jhPrint("애플 이메일 등록 성공")
                        } else {
                            jhPrint("애플 이메일 등록 실패")
                        }
                        UserInfoStore.shared.signType = .apple
                        completion(true)
                    }
                default:
                    jhPrint("안됩니다.", isWarning: true)
            }
        case .failure(let failure):
            jhPrint(failure.localizedDescription)
            jhPrint("error")
                completion(false)
        }
    }
    
    /// 애플 로긴 상태 체크하는 메서드
    func checkAppleLoginState() {
        guard let appleTokenData = KeychainService.shared.load(key: .appleUserID),
              let token = String(data: appleTokenData, encoding: .utf8) else {
            jhPrint("appleUserID이 없습니다.", isWarning: true)
            return
        }
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        appleIdProvider.getCredentialState(forUserID: token) { (credentialState, error) in
            switch credentialState {
                case .revoked:
                    jhPrint("revoked")
                case .authorized:
                    jhPrint("authorized")
                case .notFound:
                    jhPrint("notFound")
                case .transferred:
                    jhPrint("transferred")
                @unknown default:
                    fatalError()
            }
        }
    }
    
    /// 애플 토큰 리프레쉬
    func getAppleRefreshToken(completion: @escaping (String?) -> Void) {
        // 키체인에서 appleToken 불러오기
        guard let appleTokenData = KeychainService.shared.load(key: .appleAccessToken),
              let appleToken = String(data: appleTokenData, encoding: .utf8) else {
            jhPrint("appleToken이 없습니다.", isWarning: true)
            completion(nil)
            return
        }
        guard let clientSecretData = KeychainService.shared.load(key: .appleJWT),
              let clientSecret = String(data: clientSecretData, encoding: .utf8) else {
            jhPrint("JWT가 없어요.")
            completion(nil)
            return
        }

        let url = "https://appleid.apple.com/auth/token?client_id=\(bundle)&client_secret=\(clientSecret)&code=\(appleToken)&grant_type=authorization_code"
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<500)
            .responseData { response in
                switch response.result {
                case .success(let output):
                    if let decodedData = try? JSONDecoder().decode(AppleJWT.self, from: output) {
                        completion(decodedData.refresh_token)
                    } else {
                        jhPrint("디코딩 실패")
                        completion(nil)
                    }
                case .failure(let error):
                    jhPrint("애플 토큰 발급 실패 - \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
    
    func getAppleToKenInSachoSaeng() {
        let path = "/api/v1/auth/apple-token"
        NetworkService.shared.performRequest(method: "GET", path: path, body: nil, token: KeychainService.shared.getSachoSaengAccessToken()) { (result: Result<Response<ResponseAppleToken>, NetworkError>) in
            switch result {
                case .success(let appleToken):
                    if KeychainService.shared.save(key: .appleJWT, data: appleToken.data.appleToken.data(using: .utf8)!) {
                        jhPrint("\(appleToken.data.appleToken.data(using: .utf8)!)애플토큰 키체인에 등록완료")
                    } else {
                        jhPrint("애플토큰 키체인에 등록실패")
                    }
                case .failure(let error):
                    jhPrint("애플 토큰 발급 실패 - \(error.localizedDescription)")
            }
        }
    }
//    func logout() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        if let userID = KeychainService.shared.getAppleUserId() {
//            appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
//                switch credentialState {
//                    case .revoked:
//                        // 자격 증명이 철회되었음
//                        self.clearLocalAppleData()
//                        print("Apple ID 자격 증명 철회 완료")
//
//                    case .authorized:
//                        // 자격 증명이 여전히 유효함
//                        self.clearLocalAppleData()
//                        print("Apple ID 자격 증명 여전히 유효하지만 로그아웃 처리됨")
//
//                    case .notFound:
//                        // 자격 증명을 찾을 수 없음
//                        self.clearLocalAppleData()
//                        print("Apple ID 자격 증명을 찾을 수 없음")
//
//                    default:
//                        break
//                    }
//            }
//        }
//    }
    /// 애플 탈퇴
    func revokeAppleToken(completion: @escaping (Bool) -> Void) {
        getAppleRefreshToken { token in
            guard let refreshToken = token else {
                jhPrint("refreshToken을 가져오는 데 실패했습니다.", isWarning: true)
                return completion(false)
            }
            guard let clientSecretData = KeychainService.shared.load(key: .appleJWT),
                  let clientSecret = String(data: clientSecretData, encoding: .utf8) else {
                jhPrint("JWT가 없어요.")
                
                return completion(false)
            }
            let url = "https://appleid.apple.com/auth/revoke?client_id=\(self.bundle)&client_secret=\(clientSecret)&token=\(refreshToken)&token_type_hint=refresh_token"
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
            
            AF.request(url, method: .post, headers: headers)
                .validate(statusCode: 200..<600)
                .responseData { response in
                    guard let statusCode = response.response?.statusCode else {
                        jhPrint("응답에서 상태 코드를 가져올 수 없습니다.", isWarning: true)
                        return completion(false)
                    }
                    if statusCode == 200 {
                        completion(true)
                    } else {
                        jhPrint("토큰 폐기 실패: \(statusCode)", isWarning: true)
                        completion(false)
                    }
                }
        }
    }

    
    // MARK: - 사초생 API
    /// 토큰 재발급
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshTokenData = KeychainService.shared.load(key: .sachosaengRefreshToken),
              let refreshToken = String(data: refreshTokenData, encoding: .utf8) else {
            jhPrint("Refresh token이 없습니다.", isWarning: true)
            return completion(false)
        }

        let path = "/api/v1/auth/refresh"
        let headers = [
            "Cookie": "Refresh=\(refreshToken)",
            "X-Device": UserInfoStore.shared.deviceInfo
        ]

        NetworkService.shared.performRequest(method: "POST", path: path, body: nil, token: nil, headers: headers) { (result: Result<Response<RefreshData>, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if KeychainService.shared.save(key: .sachosaengAccessToken, data: response.data.accessToken.data(using: .utf8)!) {
                        jhPrint("\(response.data.accessToken.data(using: .utf8)!)Access token 키체인에 저장 완료")
                    }
                    if KeychainService.shared.save(key: .sachosaengRefreshToken, data: response.data.refreshToken.data(using: .utf8)!) {
                        jhPrint("Refresh token 키체인에 저장 완료")
                    }
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
        
        let body = ["email": KeychainService.shared.getUserEmail()!]
        let path = isApple ? "/api/v1/auth/login?type=APPLE" : "/api/v1/auth/login"
        let header = ["X-Device" : UserInfoStore.shared.deviceInfo]
        
        NetworkService.shared.performRequest(method: "POST", path: path, body: body, token: nil, headers: header) { (result: Result<AuthResponse, NetworkError>) in
            switch result {
            case .success(let response):
                    DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    UserInfoStore.shared.userId = response.data.userId
//                    jhPrint(response.data.accessToken)
                    if KeychainService.shared.save(key: .sachosaengAccessToken, data: response.data.accessToken.data(using: .utf8)!) {
                        jhPrint("Access token 키체인에 저장 완료")
                    }
                    if KeychainService.shared.save(key: .sachosaengRefreshToken, data: response.data.refreshToken.data(using: .utf8)!) {
                        jhPrint("Refresh token 키체인에 저장 완료")
                    }
                    getAppleToKenInSachoSaeng()
                    UserDefaults.standard.setValue(UserInfoStore.shared.signType.rawValue, forKey: .signType)
                    completion(true)
                }
            case .failure(let error):
                jhPrint("Error: \(error.localizedDescription)", isWarning: true)
                completion(false)
            }
        }
    }
    
    /// 사용자 회원탈퇴
    func withdrawUserAccount(_ reason: String) {
        let body = ["reason": reason]
        
        switch UserInfoStore.shared.signType {
        case .apple:
            revokeAppleToken { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    checkAppleLoginState()
                } else {
                    jhPrint("애플 회원탈퇴 실패")
                }
            }
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
        
        NetworkService.shared.performRequest(method: "POST", path: "/api/v1/auth/withdraw", body: body, token: KeychainService.shared.getSachoSaengAccessToken()) { (result: Result<Response<EmptyData>, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    UserInfoStore.shared.resetUserInfoStore()
                    KeychainService.shared.deleteAll()
                    jhPrint("탈퇴 성공\(response.data)")
                }
            case .failure(let error):
                jhPrint("탈퇴 실패: \(error)")
            }
        }
        
    }
    // 사용자 회원가입
    func registerUser(isApple: Bool = false, completion: @escaping (AuthTypeKeys) -> Void) {
        guard let email = KeychainService.shared.getUserEmail() else { return }
        
        let body = [
            "email": email,
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
        UserInfoStore.shared.resetUserInfoStore()
        KeychainService.shared.deleteAll()
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
}
