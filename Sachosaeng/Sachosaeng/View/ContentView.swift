//
//  ContentView.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    var kakao = KakaoAuthService()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button {
                kakao.loginWithKakaoAccount()
            } label: {
                Text("테스트")
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
