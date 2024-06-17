//
//  SignView.swift
//  Sachosaeng
//
//  Created by LJh on 4/9/24.
//

import SwiftUI

enum SignSpace {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.width
}

struct SignView: View {
    private var signStore = SignStore()
    var body: some View {
        VStack {
            
            Spacer()
            Button {
                signStore.loginWithKakaoAccount()
            } label: {
                Image("kakaoLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: SignSpace.screenWidth - 40, height: 55)
            }
            ZStack {
                
                Image("appleLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: SignSpace.screenWidth - 40, height: 55)
                AppleSignInButton()
                    .frame(width: SignSpace.screenWidth - 40, height: 55)
                    .blendMode(.overlay)
                    .opacity(0.02)
                    .allowsHitTesting(true)
            }
        }
    }
}

#Preview {
    SignView()
}
