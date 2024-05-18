//
//  SignView.swift
//  Sachosaeng
//
//  Created by LJh on 4/9/24.
//

import SwiftUI

struct SignView: View {
    var body: some View {
        Button {
            KakaoAuthService().loginWithKakaoAccount()
        } label: {
            Text("sss")
        }

    }
}

#Preview {
    SignView()
}
