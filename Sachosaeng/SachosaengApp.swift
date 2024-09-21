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
import GoogleSignIn

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Thread.sleep(forTimeInterval: 2.0)
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}

@main
struct SachosaengApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    init() {
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey: kakaoAppKey)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                ConsentView(isFirstLaunch: $isFirstLaunch)
            } else {
                ContentView()
                    .environmentObject(SignStore())
                    .environmentObject(UserService.shared)
                    .environmentObject(VersionService.shared)
                    .environmentObject(UserInfoStore.shared)
                    .environmentObject(TabBarStore())
                    .onOpenURL(perform: { url in
                        GIDSignIn.sharedInstance.handle(url)
                        
                        if AuthApi.isKakaoTalkLoginUrl(url) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    })
            }
        }
    }
}
