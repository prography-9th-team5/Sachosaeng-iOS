//
//  ContentView.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    @State var isSign: Bool = false
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            switch isSign {
                case true:
                    SignView(path: $path, isSign: $isSign)
                case false:
                    TabView(isSign: $isSign, path: $path)
            }
        }
    }
}

#Preview {
    ContentView()
}
