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
    @EnvironmentObject var userService: UserService
    @State var isSign: Bool = true
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            SignView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, path: $path, isSign: $isSign)
                .environmentObject(userService)
                .navigationDestination(for: PathType.self) { name in
                    switch name {
                        case .occupation:
                            UserOccupationView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, isSign: $isSign, path: $path)
                                .navigationBarBackButtonHidden()
                                .environmentObject(userService)
                        case .favorite:
                            UserFavoriteCategoryView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, isSign: $isSign, path: $path)
                                .customBackbutton {
//                                    jhPrint("😿 네비게이션 패스의 갯수: \(path.count)")
                                }
                                .environmentObject(userService)
                        case .signSuccess:
                            SignSuccessView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, isSign: $isSign, path: $path)
                                .navigationBarBackButtonHidden()
                                .environmentObject(userService)
                        case .home:
                            TabView(isSign: $isSign, path: $path)
                        case .myPage:
                            MyPageView(isSign: $isSign, path: $path)
                                .customBackbutton {
//                                    jhPrint("😿 네비게이션 패스의 갯수: \(path.count)")
                                }
                                .environmentObject(userService)
                        case .info:
                            EditMyInfoView(isSign: $isSign, path: $path)
                                .customBackbutton {
//                                    jhPrint("😿 네비게이션 패스의 갯수: \(path.count)")
                                }
                                .environmentObject(userService)
                        case .quit:
                            QuitView(isSign: $isSign, path: $path)
                                .customBackbutton {
//                                    jhPrint("😿 네비게이션 패스의 갯수: \(path.count)")
                                }
                                .environmentObject(userService)
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
