//
//  SachosaengApp.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

@main
struct SachosaengApp: App {
    
    init() {
        if let test1 = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            print(test1)
        }
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}
