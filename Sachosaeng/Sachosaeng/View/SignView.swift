//
//  SignView.swift
//  Sachosaeng
//
//  Created by LJh on 4/9/24.
//

import SwiftUI
import GoogleSignInSwift

enum PhoneSpace {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.width
}

struct SignView: View {
    private var signStore = SignStore()
    var body: some View {
        VStack {
            Text("테스트")
                .font(.createFont(weight: .thin, size: 28))
            Spacer()
            ZStack {
                Image("appleLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                AppleSignInButton()
                    .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                    .blendMode(.overlay)
                    .opacity(0.02)
                    .allowsHitTesting(true)
            } //: ZStack
            
            Button {
                signStore.loginWithKakaoAccount()
            } label: {
                Image("kakaoLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: PhoneSpace.screenWidth - 40, height: 55)
            }
            
            ZStack {
                Image("googleLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                GoogleSignInButton {
                    signStore.signInGoolge()
                }
                    .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                    .blendMode(.overlay)
                    .opacity(0.02)
                    .allowsHitTesting(true)
            } //: ZStack
        }
    }
}

#Preview {
    SignView()
}
