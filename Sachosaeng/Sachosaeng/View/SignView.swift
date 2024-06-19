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
            Group {
                HStack {
                    Text("사초생과 함께\n사회생활 고민을 풀어봐요!")
                        .font(.createFont(weight: .medium, size: 26))
                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                        .lineSpacing(10)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .padding(.top, 50)
                HStack {
                    Text("사회초년생 집단지성 투표 플랫폼")
                        .font(.createFont(weight: .light, size: 16))
                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
            } //: Group
            
            Spacer()
            TempImageView(isBorder: true, width: PhoneSpace.screenWidth - 100, height: PhoneSpace.screenWidth - 100)
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
