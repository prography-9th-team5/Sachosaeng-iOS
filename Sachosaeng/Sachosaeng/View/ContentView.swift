//
//  ContentView.swift
//  Sachosaeng
//
//  Created by LJh on 4/8/24.
//

import SwiftUI
import KakaoSDKAuth

struct ContentView: View {
    @StateObject var categoryStore = CategoryStore()
    @StateObject var voteStore: VoteStore = VoteStore()
    @StateObject var bookmarkStore: BookmarkStore = BookmarkStore()
    @EnvironmentObject var signStore: SignStore
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var versionService: VersionService
    @EnvironmentObject var userInfoStore: UserInfoStore
    @State var isPopUpView: Bool = false
    @State var isPopUpType: PopupType?
    @State var isSign: Bool = true
    @State var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            SignView(categoryStore: categoryStore, voteStore: voteStore, path: $path, isSign: $isSign)
                .navigationDestination(for: PathType.self) { name in
                    switch name {
                    case .occupation:
                        UserOccupationView(categoryStore: categoryStore, voteStore: voteStore, isSign: $isSign, path: $path)
                            .navigationBarBackButtonHidden()
                    case .favorite:
                        UserFavoriteCategoryView(categoryStore: categoryStore, voteStore: voteStore, isSign: $isSign, path: $path)
                            .customBackbutton {
//                                    jhPrint("😿 네비게이션 패스의 갯수: \(path.count)")
                            }
                    case .signSuccess:
                        SignSuccessView(categoryStore: categoryStore, voteStore: voteStore, isSign: $isSign, path: $path)
                            .navigationBarBackButtonHidden()
                    case .home:
                        TabView(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore, isSign: $isSign, path: $path)
                    case .myPage:
                        MyPageView(isSign: $isSign, path: $path)
                            .customBackbutton {
//                                    jhPrint("😿 네비게이션 패스의 갯수: \(path.count)")
                            }
                    case .info:
                        EditMyInfoView(isSign: $isSign, path: $path)
                            .customBackbutton {
//                                    jhPrint("😿 네비게이션 패스의 갯수: \(path.count)")
                            }
                    case .quit:
                        QuitView(isSign: $isSign, path: $path)
                            .customBackbutton {
//                                    jhPrint("😿 네비게이션 패스의 갯수: \(path.count)")
                            }
                    case .sign:
                        SignView(categoryStore: CategoryStore(), voteStore: VoteStore(), path: $path, isSign: $isSign)
                    case .daily:
                        DailyVoteDetailView(voteStore: voteStore, bookmarkStore: bookmarkStore, voteId: voteStore.dailyVote.voteId, path: $path)
                    case .usersFavorite:
                        FavoriteCategoryView(categoryStore: categoryStore, path: $path)
                    case .inquiry:
                        EmptyView()
                    case .openSource:
                        EmptyView()
                    case .userData:
                        EmptyView()
                    case .service:
                        EmptyView()
                    case .FAQ:
                        EmptyView()
                    }
                }
        }
        .showPopupView(isPresented: $isPopUpView, message: isPopUpType ?? .forceUpdate, primaryAction: {
            signStore.refreshToken { isSuccess in
                if isSuccess {
                    userService.getUserInfo()
                    userInfoStore.performSetSignType()
                    categoryStore.fetchCategories()
                    path.append(PathType.home)
                }
            }
        }, secondaryAction: {
                DispatchQueue.main.async {
                    guard let appleID = Bundle.main.object(forInfoDictionaryKey: "AppleId") as? String,
                          let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleID)"),
                          UIApplication.shared.canOpenURL(url) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
        })
        .onAppear {
            versionService.verifyVersion { isForceUpdateRequired, isLatest  in
                if isForceUpdateRequired {
                    isPopUpType = .forceUpdate
                    isPopUpView = true
                } else {
                    if !isLatest {
                        signStore.refreshToken { isSuccess in
                            if isSuccess {
                                userService.getUserInfo()
                                userInfoStore.performSetSignType()
                                categoryStore.fetchCategories()
                                path.append(PathType.home)
                            }
                        }
                    } else {
                        isPopUpType = .latestVersion
                        isPopUpView = true
                    }
                }
            }
        }
    }
}
