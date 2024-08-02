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

class SignStore: ObservableObject {
    func loginWithKakaoAccount() {
        func handleLoginError(_ error: Error) {
            jhPrint(error.localizedDescription)
        }
        
        func handleOAuthToken(_ oauthToken: OAuthToken?) {
            guard let idToken = oauthToken?.idToken else {
                jhPrint("oauthToken 받아오기 실패")
                return
            }
            jhPrint(idToken)
            getKakaoUser()
        }
        
        func loginWithKakaoTalk() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    handleLoginError(error)
                } else {
                    handleOAuthToken(oauthToken)
                }
            }
        }
        
        if UserApi.isKakaoTalkLoginAvailable() {
            if AuthApi.hasToken() {
                jhPrint("토큰있음")
                UserApi.shared.accessTokenInfo { (_, error) in
                    if let error = error, let sdkError = error as? SdkError, sdkError.isInvalidTokenError() {
                        loginWithKakaoTalk()
                    } else if let error = error {
                        handleLoginError(error)
                    } else {
                        // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    }
                }
            } else {
                jhPrint("토큰없음")
                loginWithKakaoTalk()
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    handleLoginError(error)
                } else {
                    handleOAuthToken(oauthToken)
                }
            }
        }
    }
    
    /// 유저 데이터 가져오기
    func getKakaoUser() {
        UserApi.shared.me { user, error in
            if let error = error {
                jhPrint("유저 데이터를 가져오는 데 실패했습니다. \(error.localizedDescription)")
            } else if let email = user?.kakaoAccount?.email {
                UserStore.shared.currentUserEmail = email
                jhPrint("이메일 찾기 \(email)")
            } else {
                jhPrint("이메일을 찾을 수 없습니다.")
            }
        }
    }
    
    /// 카카오톡 회원탈퇴 시키기
    func logoutOfKakaoTalk() {
        UserApi.shared.unlink {(error) in
            if error != nil {
                jhPrint(error!.localizedDescription)
            } else {
                jhPrint("kakaoUnLink success.")
            }
        }
    }
    
    /// 구글로그인(미완성: 메서드 완성시켜야함)
    func signInGoogle(completion: @escaping (Bool) -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            completion(false)
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                jhPrint("Google Sign-In Error: \(error.localizedDescription)")
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
    
    /// api authJoin - 회원가입 입니다.
    func authJoin() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "sachosaeng.store"
        urlComponents.path = "/api/v1/auth/join"
        
        guard let url = urlComponents.url else {
            jhPrint("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": UserStore.shared.currentUserEmail]
        jhPrint(body)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            jhPrint("Error creating JSON data")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                jhPrint("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                jhPrint("Unexpected error: No data or response")
                return
            }
            
            jhPrint("Response status code: \(response.statusCode)")
            
            if (200..<300).contains(response.statusCode) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        jhPrint(json)
                    }
                } catch {
                    jhPrint("Error parsing JSON response")
                }
            } else {
                let responseData = String(data: data, encoding: .utf8)
                jhPrint("\(response.statusCode) data: \(responseData ?? "No data")")
            }
        }
        task.resume()
    }
}
