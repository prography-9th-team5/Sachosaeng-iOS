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

final class KakaoAuthService {
    /// 카카오 로그인 시도
    func loginWithKakaoAccount() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { _, error in
                if let error = error {
                    print("=================에러1===============")
                    print("if loginWithKakaoAccount \(error)")
                } else {
                    self.getUser()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (_, error) in
                if let error = error {
                    print("=================에러2===============")
                    print(error.localizedDescription)
                    print("else loginWithKakaoAccount\(error)")
                } else {
                    self.getUser()
                    print("loginWithKakaoAccount() success.")
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
        UserApi.shared.logout { error in
            if let error = error {
                print(error)
            }
        }
    }
}
