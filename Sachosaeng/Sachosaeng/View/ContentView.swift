//
//  ContentView.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI
import KakaoSDKAuth

struct ContentView: View {
    @ObservedObject var categoryStore = CategoryStore()
    @ObservedObject var voteStore: VoteStore = VoteStore()
    @ObservedObject var signStore: SignStore = SignStore()
    @State var isSign: Bool = true
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            SignView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, path: $path, isSign: $isSign)
                .navigationDestination(for: PathType.self) { name in
                    switch name {
                    case .occupation:
                        UserOccupationView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, isSign: $isSign, path: $path)
                            .navigationBarBackButtonHidden()
                        
                    case .favorite:
                        UserFavoriteCategoryView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, isSign: $isSign, path: $path)
                            .customBackbutton()
                        
                    case .signSuccess:
                        SignSuccessView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, isSign: $isSign, path: $path)
                            .navigationBarBackButtonHidden(true)
                        
                    case .home:
                        TabView(isSign: $isSign, path: $path)
                        
                    case .myPage:
                        MyPageView(isSign: $isSign, path: $path)
                            .customBackbutton {
                                jhPrint("""
                                        😿 네비게이션 패스의 갯수: \(path.count)
                                        😿 네비게이션 패스: \(path)
                                        """)
                            }
                        
                    case .info:
                        EditMyInfoView(isSign: $isSign, path: $path)
                            .customBackbutton {
                                jhPrint("""
                                        😿 네비게이션 패스의 갯수: \(path.count)
                                        😿 네비게이션 패스: \(path)
                                        """)
                            }
                        
                    case .quit:
                        QuitView(isSign: $isSign, path: $path)
                            .customBackbutton {
                                jhPrint("""
                                        😿 네비게이션 패스의 갯수: \(path.count)
                                        😿 네비게이션 패스: \(path)
                                        """)
                            }
                    case .sign:
                        SignView(categoryStore: CategoryStore(), voteStore: VoteStore(), signStore: SignStore(), path: $path, isSign: $isSign)
                    }
                }
        }
        .onAppear {
            Task {
                await categoryStore.fetchCategories()
            }
        }
    }
}


#Preview {
    ContentView()
}
