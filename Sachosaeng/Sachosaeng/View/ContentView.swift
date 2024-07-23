//
//  ContentView.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    @State var isSign: Bool = false
    @State var path = NavigationPath()
    
    var body: some View {
        switch !isSign {
        case true:
            NavigationStack(path: $path) {
                MainView(path: $path)
            }
        case false:
            NavigationStack {
                UserOccupationView(isSign: $isSign)
            }
        }
    }
}

#Preview {
    ContentView()
}
