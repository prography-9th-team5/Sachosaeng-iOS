//
//  SachosaengApp.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

@main
struct SachosaengApp: App {
    init() {
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey: kakaoAppKey)
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
