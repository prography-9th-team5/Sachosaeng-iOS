//
//  KakaoAuthService.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import Foundation
import KakaoSDKUser

final class KakaoAuthService {
    /// 카카오 로그인 시도
    func loginWithKakaoAccount() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { _, error in
                if let error = error {
                    print(error)
                } else {
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (_, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                }
            }
        }
    }
}
