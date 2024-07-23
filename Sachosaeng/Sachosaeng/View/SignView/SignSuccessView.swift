//
//  SignSuccessView.swift
//  Sachosaeng
//
//  Created by LJh on 6/21/24.
//

import SwiftUI

struct SignSuccessView: View {
    @State private var isActive: Bool = false
    @Binding var isSign: Bool
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
                Image("온보딩_\(UserStore.shared.newUser.userType)")
                    .frame(width: 248,
                           height: 248)
                Spacer()
                
            }
            .padding(.top, 70)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isActive = true
                    isSign = true
                }
            }
        }
}

#Preview {
    NavigationStack {
        SignSuccessView(isSign: .constant(true))
    }
}
