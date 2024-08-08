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
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @State private var isActive: Bool = false
    var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    CommonTitle(top: "랜덤이름님!",
                                topFont: .bold,
                                middle: "사초생에 오신 걸 환영해요",
                                middleFont: .bold,
                                footer: "회원가입 완료",
                                footerFont: .medium, isSuccessView: true)
                }
                .frame(height: 100)
                .padding(.bottom, 45)
                Image("온보딩_\(UserStore.shared.currentUserState.userType)")
                    .frame(width: 248,
                           height: 248)
                Spacer()
                
            }
            .padding(.top, 70)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isActive = true
                    path.append(PathType.home)
                    isSign = false
                }
            }
        }
}
