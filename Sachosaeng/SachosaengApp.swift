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
import Lottie
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics

@main
struct SachosaengApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @StateObject var userSerVice: UserService = UserService.shared
    @StateObject var userInfoStore: UserInfoStore = UserInfoStore.shared
    @StateObject var versionService: VersionService = VersionService.shared
    @StateObject var signStore: SignStore = SignStore()
    @StateObject var tabBarStore: TabBarStore = TabBarStore()
    @Environment(\.scenePhase) private var scenePhase
    @State private var isBackground = false
    @State private var rotateImage = false
    @State private var scaleImage = false
    
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
                    .environmentObject(signStore)
                    .environmentObject(userSerVice)
                    .environmentObject(versionService)
                    .environmentObject(userInfoStore)
                    .environmentObject(tabBarStore)
                    .onOpenURL(perform: { url in
                        GIDSignIn.sharedInstance.handle(url)
                        
                        if AuthApi.isKakaoTalkLoginUrl(url) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    })
                    .overlay {
                        // 백그라운드일 때 이미지 덮어 씌우기
                       if isBackground && ViewTracker.shared.currentView != .sign {
                           ZStack {
                               CustomColor.GrayScaleColor.white.ignoresSafeArea()
                               Image("RollingC")
                                   .rotationEffect(Angle.degrees(rotateImage ? 360 : 0))
                                   .scaleEffect(scaleImage ? 1.2 : 1.0)
                                   .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: rotateImage)
                                   .onAppear {
                                       rotateImage = true
                                       scaleImage = true
                                   }
                                   .onDisappear {
                                       rotateImage = false
                                       scaleImage = false
                                   }
                           }
                       }
                    }
            }
        }
        .onChange(of: scenePhase) { newPhase in
             if newPhase == .active {
                jhPrint("활성화")
                 withAnimation {
                     isBackground = false
                 }
             } else if newPhase == .inactive  {
                jhPrint("비활성화 되기전 ")
                withAnimation {
                    isBackground = true
                }
             }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Thread.sleep(forTimeInterval: 2.0)
//
//        FirebaseApp.configure()
//        Analytics.setAnalyticsCollectionEnabled(true)
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}
