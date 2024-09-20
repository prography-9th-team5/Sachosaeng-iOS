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
    @ObservedObject var bookmarkStore: BookmarkStore = BookmarkStore()
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var versionService: VersionService
    @State var isSign: Bool = true
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            SignView(categoryStore: categoryStore, voteStore: voteStore, signStore: signStore, path: $path, isSign: $isSign)
                .environmentObject(userService)
                .environmentObject(versionService)
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
                            TabView(isSign: $isSign, path: $path, categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore)
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
                        case .daily:
                            DailyVoteDetailView(voteId: voteStore.dailyVote.voteId, voteStore: voteStore, bookmarkStore: BookmarkStore(), path: $path)
                    }
                }
        }
        .onAppear {
            versionService.verifyVersion()
        }
    }
}


#Preview {
    ContentView()
}
