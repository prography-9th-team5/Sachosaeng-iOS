//
//  SignView.swift
//  Sachosaeng
//
//  Created by LJh on 4/9/24.
//

import SwiftUI
import GoogleSignInSwift
import _AuthenticationServices_SwiftUI
import FirebaseAnalytics

enum PhoneSpace {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

struct SignView: View {
    @ObservedObject var categoryStore: CategoryStore
    @ObservedObject var voteStore: VoteStore
    @EnvironmentObject var signStore: SignStore
    @EnvironmentObject var versionService: VersionService
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var userInfoStore: UserInfoStore
    @ObservedObject var userStore = UserInfoStore.shared
    @Binding var path: NavigationPath
    @Binding var isSign: Bool
    @State var isPopUpView: Bool = false
    @State var isPopUpType: PopupType?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            CommonTitle(top: "궁금했던 사회생활",
                        topFont: .bold,
                        middle: "사초생이 모두 알려줄게요",
                        middleFont: .bold,
                        footer: "사회초년생 집단지성 투표 플랫폼, 사초생",
                        footerFont: .medium, isSuccessView: false)
            
            Group {
                Spacer()
                Image("Onboarding image")
                Spacer()
            }
            
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
                            Image("apple")
                                .frame(width: 28, height: 28)
                                .padding(12)
                        }
                    SignInWithAppleButton(
                        .continue,
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            signStore.loginApple(result: result) { success in
                                if success {
                                    performSignApple()
                                }
                            }
                        }
                    )
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
                            Image("kakao")
                                .frame(width: 28, height: 28)
                                .padding(12)
                        }
                }
                .padding(.bottom, 8)

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(CustomColor.GrayScaleColor.gs4, lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(CustomColor.GrayScaleColor.gs1)
                        )
                        .frame(width: PhoneSpace.screenWidth - 40, height: 55)
                        .overlay(alignment: .center) {
                            Text("Google로 로그인")
                                .font(.createFont(weight: .semiBold, size: 16))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                        }
                        .overlay(alignment: .leading) {
                            Image("google")
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
        .showPopupView(isPresented: $isPopUpView, message: isPopUpType ?? .forceUpdate, primaryAction: {
            signStore.refreshToken { isSuccess in
                if isSuccess {
                    userService.getUserInfo()
                    userInfoStore.performSetSignType()
                    categoryStore.fetchCategories()
                    path.append(PathType.home)
                }
            }
        }, secondaryAction: {
                DispatchQueue.main.async {
                    guard let appleID = Bundle.main.object(forInfoDictionaryKey: "AppleId") as? String,
                          let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleID)"),
                          UIApplication.shared.canOpenURL(url) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
        })
        .onAppear {
            Task {
                ViewTracker.shared.currentView = .sign
            }
        }
    }
}

extension SignView {
    private func performSignApple() {
        versionService.verifyVersion { isForceUpdateRequired, _ in
            if isForceUpdateRequired {
                isPopUpType = .forceUpdate
                isPopUpView = true
            } else {
                signStore.registerUser(isApple: true) { type in
                    switch type {
                    case .success:
                        signStore.loginUser(isApple: true) { isSuccessAuthLogin in
                            if isSuccessAuthLogin {
                                path.append(PathType.occupation)
                            }
                        }
                    case .failed:
                        jhPrint("실패")
                    case .userExists:
                        signStore.loginUser(isApple: true) { isSuccessAuthLogin in
                            if isSuccessAuthLogin {
                                userService.getUserInfo()
                                userService.getUserCategories()
                                path.append(PathType.home)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func performSignLogic() {
        versionService.verifyVersion { isForceUpdateRequired, _ in
            if isForceUpdateRequired {
                isPopUpType = .forceUpdate
                isPopUpView = true
            } else {
                signStore.registerUser { type in
                    switch type {
                        case .success:
                            signStore.loginUser { isSuccessAuthLogin in
                                if isSuccessAuthLogin {
                                    path.append(PathType.occupation)
                                }
                            }
                        case .failed:
                            jhPrint("실패")
                        case .userExists:
                            signStore.loginUser { isSuccessAuthLogin in
                                if isSuccessAuthLogin {
                                    userService.getUserInfo()
                                    userService.getUserCategories()
                                    path.append(PathType.home)
                                }
                            }
                    }
                }
            }
        }
    }
}
