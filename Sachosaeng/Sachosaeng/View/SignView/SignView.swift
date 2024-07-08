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
    @ObservedObject var signStore = SignStore()
    @Binding var isSign: Bool
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                CommonTitle(top: "궁금했던 사회생활",
                            topFont: .bold,
                            middle: "사초생이 모두 알려줄게요",
                            middleFont: .bold,
                            footer: "사회초년생 집단지성 투표 플랫폼, 사초생",
                            footerFont: .medium, isSuccessView: false)
                
                Spacer()
                
                Image("Onboarding image")
                Spacer()
                
                VStack(spacing: 0) {
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
                    .padding(.bottom, 8)
                    Button {
                        signStore.loginWithKakaoAccount()
                    } label: {
                        Image("kakaoLogin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                    }
                    .padding(.bottom, 8)

                    ZStack {
                        Image("googleLogin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                        GoogleSignInButton {
                            signStore.signInGoogle { success in
                                if success {
                                }
                            }
                        }
                        .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                        .blendMode(.overlay)
                        .opacity(0.02)
                        .allowsHitTesting(true)
                    } //: ZStack
                    .padding(.bottom, 8)
                } //: Vstack
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    SignView(isSign: .constant(true))
}
// TODO: 로그인기능을 백이랑 연결하는 작업 해야함 (기능 제대로 구현 하기)
