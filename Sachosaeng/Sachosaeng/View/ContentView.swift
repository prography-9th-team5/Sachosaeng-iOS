//
//  ContentView.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var categoryStore = CategoryStore()
    @ObservedObject var voteStore: VoteStore = VoteStore()
    @ObservedObject var signStore: SignStore = SignStore()
    @State var isSign: Bool = true
    @State var path: NavigationPath = NavigationPath()
    @State var homePath: NavigationPath = NavigationPath()
    
    var body: some View {
        switch !isSign {
            case true:
                NavigationStack(path: $path) {
                    SignView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, path: $path, isSign: $isSign)
                    
                } 
                .onAppear {
                    Task {
                        await categoryStore.fetchCategories()
                    }
                }
                
            case false:
                NavigationStack(path: $homePath) {
                    TabView(isSign: $isSign, path: $homePath)
                        .navigationBarBackButtonHidden()
                }
        }
    }
}

#Preview {
    ContentView()
}
