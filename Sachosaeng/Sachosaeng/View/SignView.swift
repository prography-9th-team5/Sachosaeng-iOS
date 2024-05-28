//
//  SignView.swift
//  Sachosaeng
//
//  Created by LJh on 4/9/24.
//

import SwiftUI
import AuthenticationServices

struct SignView: View {
    private var signStore = SignStore()
    var body: some View {
        VStack {
            Button {
                signStore.loginWithKakaoAccount()
            } label: {
                Text("sss")
            }
            AppleSignInButton()
        }
    }
}

#Preview {
    SignView()
}
