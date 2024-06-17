//
//  ContentView.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SignView()
                .tabItem {
                    Image(systemName: ".")
                }
        }
    }
}

#Preview {
    ContentView()
}
