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

final class SignStore: ObservableObject {
    @Published var nowSignEmail: String = ""
    
    func loginWithKakaoAccount() {
//        AuthApi.shared.refreshToken { token, _ in
//            print("토큰 갱신 : newToken = (newToken)")
//        }
        
        if (AuthApi.hasToken()) {
            myLogPrint("토큰있음")
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        if UserApi.isKakaoTalkLoginAvailable() {
                            myLogPrint("카카오톡 있음")
                            UserApi.shared.loginWithKakaoTalk(launchMethod: .CustomScheme) {(oauthToken, error) in
                                if let error = error {
                                    myLogPrint("if loginWithKakaoAccount \(error.localizedDescription)")
                                } else {
                                    myLogPrint("getuser 성공")
                                    self.getUser()
                                }
                            }
                        } else {
                            myLogPrint("카카오톡 없음")
                            UserApi.shared.loginWithKakaoAccount { (_, error) in
                                if let error = error {
                                    myLogPrint("if loginWithKakaoAccount \(error.localizedDescription)")
                                } else {
                                    self.getUser()
                                    print("loginWithKakaoAccount() success.")
                                }
                            }
                        }
                    }
                    else {
                        myLogPrint("기타입니다")
                    }
                }
                else {
                    myLogPrint("토큰 유효성 체크 성공(필요 시 토큰 갱신됨)")
                }
            }
        }
        else {
            myLogPrint("토큰없음")
            if UserApi.isKakaoTalkLoginAvailable() {
                myLogPrint("카카오톡 있음")
                UserApi.shared.loginWithKakaoTalk(launchMethod: .CustomScheme) {(oauthToken, error) in
                    if let error = error {
                        myLogPrint("if loginWithKakaoAccount \(error.localizedDescription)")
                    } else {
                        myLogPrint("getuser 성공")
                        self.getUser()
                    }
                }
            } else {
                myLogPrint("카카오톡 없음")
                UserApi.shared.loginWithKakaoAccount { (_, error) in
                    if let error = error {
                        myLogPrint("if loginWithKakaoAccount \(error.localizedDescription)")
                    } else {
                        self.getUser()
                        print("loginWithKakaoAccount() success.")
                    }
                }
            }
        }
        
        
    }
    /// 유저 데이터 가져오기
    func getUser() {
        UserApi.shared.me { user, error in
            if error != nil {
                print("유저데이터 가져오는데 실패했습니다. \(String(describing: error))")
            } else {
                print("닉네임찾기 \(user?.kakaoAccount?.profile?.nickname ?? "몰루")" )
                print("이메일찾기 \(user?.kakaoAccount?.email ?? "몰루")" )
            }
        }
    }
    /// 카카오톡 로그아웃 시키기
    func logout() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print("kakaoUnLink error : (error.localizedDescription)")
            } else {
                print("kakaoUnLink success.")
        //                                UserDefaultsManager().removeAll(signInType: .kakao)
        //                                completion(true)
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
                print("Google Sign-In Error: \(error.localizedDescription)")
                completion(false)
            } else if let signInResult = signInResult {
                self.nowSignEmail = signInResult.user.profile?.email ?? ""
                print("Google Sign-In Success: \(signInResult.user.profile?.email ?? "No Name")")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    func authJoin() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "sachosaeng.store"
        urlComponents.path = "/api/v1/auth/join"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = [
                "email": self.nowSignEmail
            ] as [String: String]
            
            myLogPrint(body)
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        do {
                            // 회원가입이랑 로그인을 합쳐주세요 안그러면 저희가 이사람이 가입이 되있는지 안되어있는지판별해야하잔항여 그그러면 로그인이 오래걸리니깐 일반 로그인 이면 api 두개로 쪼개는게 맞는거 같지만 간편로그인만 있으니깬 하나로 합쳐줘요
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                myLogPrint(json)
                            }
                        } catch {
                            myLogPrint("Error parsing JSON response")
                        }
                    } else {
                        let responseData = String(data: data, encoding: .utf8)
                        print("\(response.statusCode) data: \(responseData ?? "No data")")
                    }
                } else {
                    print("Unexpected error: No data or response")
                }
            }
            task.resume()
        }
    }
    
    
//    func authJoin() {
//        struct RequestData: Codable {
//            let email: String
//        }
//        struct JoinResponse: Codable {
//            let code: Int
//            let message: String
//            let data: String
//        }
//        
//        guard let url = URL(string: "https://sachosaeng.store/api/v1/auth/join") else {
//            myLogPrint("Invalid URL : /api/v1/auth/join")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let requestData = RequestData(email: self.nowSignEmail)
//        
//        do {
//            let jsonData = try JSONEncoder().encode(requestData)
//            request.httpBody = jsonData
//        } catch {
//            myLogPrint("json으로 변환 실패했숑")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, err in
//            if let err = err {
//                myLogPrint(err )
//                return
//            }
//            
//            guard let data = data else {
//                myLogPrint("데이터를 받지 못했숑")
//                return
//            }
//            
//            do {
//                let reponseData = try JSONDecoder().decode(JoinResponse.self, from: data)
//                myLogPrint(reponseData)
//            } catch {
//                myLogPrint(String(describing: err))
//            }
//        }
//        task.resume()
//    }
}
