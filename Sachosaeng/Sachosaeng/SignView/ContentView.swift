//
//  ContentView.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // 여기서 사인이 완료되거나 이미 로그인이 되어있을경우 바로 MainView로 가야함
        UserOccupationView()
    }
}

#Preview {
    ContentView()
}
