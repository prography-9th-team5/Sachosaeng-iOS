//
//  SignSuccessView.swift
//  Sachosaeng
//
//  Created by LJh on 6/21/24.
//

import SwiftUI

struct SignSuccessView: View {
    @StateObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @StateObject var signStore: SignStore
    @ObservedObject var userStore = UserStore.shared
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @State private var isActive: Bool = false
    @State private var isImageAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                CommonTitle(top: userStore.currentUserState.nickname,
                            topFont: .bold,
                            middle: "사초생에 오신 걸 환영해요",
                            middleFont: .bold,
                            footer: "회원가입 완료",
                            footerFont: .medium, isSuccessView: true)
            }
            .frame(height: 100)
            .padding(.bottom, 45)
            
            if !isImageAnimation {
                Spacer()
                    .frame(height: 400)
            }
                
            Image("온보딩_\(userStore.currentUserState.userType)")
                .frame(width: 248, height: 248)
                .opacity(isImageAnimation ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isImageAnimation)

            Spacer()
        }
        .padding(.top, 70)
        .onAppear {
            withAnimation {
                isImageAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                userStore.convertToUserType(userStore.currentUserState.userType) {
                    isActive = true
                    isSign = false
                }
                path.append(PathType.home)
            }
        }
    }
}
