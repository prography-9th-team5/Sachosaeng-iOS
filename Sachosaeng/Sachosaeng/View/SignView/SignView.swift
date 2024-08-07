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
    static let screenHeight = UIScreen.main.bounds.height
}

struct SignView: View {

    @StateObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @StateObject var signStore: SignStore
    @Binding var path: NavigationPath
    @Binding var isSign: Bool
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            CommonTitle(top: "궁금했던 사회생활",
                        topFont: .bold,
                        middle: "사초생이 모두 알려줄게요",
                        middleFont: .bold,
                        footer: "사회초년생 집단지성 투표 플랫폼, 사초생",
                        footerFont: .medium, isSuccessView: false)
            .onTapGesture {
                path.append(PathType.occupation)
            }
            
            Spacer()
            
            Image("Onboarding image")
            
            Spacer()
            
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                        .overlay(alignment: .center) {
                            Text("Apple로 로그인")
                                .font(.createFont(weight: .semiBold, size: 16))
                                .foregroundStyle(.white)
                        }
                        .overlay(alignment: .leading) {
                            Image("애플")
                                .frame(width: 28, height: 28)
                                .padding(12)
                        }
                    AppleSignInButton()
                        .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                        .blendMode(.overlay)
                        .opacity(0.02)
                        .allowsHitTesting(true)
                } //: ZStack
                .padding(.bottom, 8)
                Button {
                    signStore.loginKakao { isSuccessLoginWithKakao in
                        if isSuccessLoginWithKakao {
                            performSignLogic()
                        }
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(Color(hex: "#FEE500"))
                        .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                        .overlay(alignment: .center) {
                            Text("카카오로 로그인")
                                .font(.createFont(weight: .semiBold, size: 16))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                        }
                        .overlay(alignment: .leading) {
                            Image("카카오")
                                .frame(width: 28, height: 28)
                                .padding(12)
                        }
                }
                .padding(.bottom, 8)

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(CustomColor.GrayScaleColor.gs4, lineWidth: 1) // 1px 검정색 보더 추가
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(CustomColor.GrayScaleColor.gs1) // 배경색
                        )
                        .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                        .overlay(alignment: .center) {
                            Text("Google로 로그인")
                                .font(.createFont(weight: .semiBold, size: 16))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                        }
                        .overlay(alignment: .leading) {
                            Image("구글")
                                .frame(width: 28, height: 28)
                                .padding(12)
                        }
                    GoogleSignInButton {
                        signStore.loginGoogle { isSuccessloginGoogle in
                            performSignLogic()
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
    private func performSignLogic() {
        signStore.authJoin { type in
            switch type {
            case .success:
                signStore.authLogin { isSuccessAuthLogin in
                    if isSuccessAuthLogin {
                        path.append(PathType.occupation)
                    }
                }
            case .failed:
                jhPrint("실패")
            case .userExists:
                signStore.authLogin { isSuccessAuthLogin in
                    if isSuccessAuthLogin {
                        path.append(PathType.home)
                    }
                }
            }
        }
    }
}

#Preview {
    SignView(categoryStore: CategoryStore(), voteStore: VoteStore(), signStore: SignStore(), path: .constant(NavigationPath()), isSign: .constant(false))
}
// TODO: 로그인기능을 백이랑 연결하는 작업 해야함 (기능 제대로 구현 하기)
