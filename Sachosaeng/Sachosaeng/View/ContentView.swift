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
                .navigationDestination(for: PathType.self) { type in
                    switch type {
                    case .occupation:
                        UserOccupationView(categoryStore: categoryStore, voteStore: voteStore, isSign: $isSign, path: $path)
                            .navigationBarBackButtonHidden()
                    case .favorite:
                        UserFavoriteCategoryView(categoryStore: categoryStore, voteStore: voteStore, isSign: $isSign, path: $path)
                            .customBackbutton { }
                    case .signSuccess:
                        SignSuccessView(categoryStore: categoryStore, voteStore: voteStore, isSign: $isSign, path: $path)
                            .navigationBarBackButtonHidden()
                    case .home:
                        TabView(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore, isSign: $isSign, path: $path)
                    case .myPage:
                        MyPageView(isSign: $isSign, path: $path)
                            .customBackbutton { }
                    case .info:
                        EditMyInfoView(isSign: $isSign, path: $path)
                            .customBackbutton { }
                    case .quit:
                        QuitView(isSign: $isSign, path: $path)
                            .customBackbutton { }
                    case .sign:
                        SignView(categoryStore: CategoryStore(), voteStore: VoteStore(), path: $path, isSign: $isSign)
                    case .daily:
                        DailyVoteDetailView(voteStore: voteStore, bookmarkStore: bookmarkStore, voteId: voteStore.dailyVote.voteId, path: $path)
                            .navigationBarBackButtonHidden()
                    case .usersFavorite:
                        FavoriteCategoryView(categoryStore: categoryStore, path: $path)
                    case .inquiry, .openSource, .userData, .service, .FAQ:
                        EmptyView()
                    case .voteDetail(let voteId):
                        VoteDetailView(voteStore: voteStore, bookmarkStore: bookmarkStore, voteId: voteId)
                    case .voteRegistration:
                        VoteRegistrationView(categoryStore: categoryStore, voteStore: voteStore)
                            .customBackbutton { }
                    case .voteHistory:
                        VoteHistoryView(voteStore: voteStore, path: $path)
                            .customBackbutton { }
                    case .registeredVotes(let voteId):
                            RegisteredVoteView(voteStore: voteStore, path: $path, voteId: voteId)
                            .customBackbutton { }
                    }
                }
        }
        .showPopupView(isPresented: $isPopUpView, message: isPopUpType ?? .forceUpdate, primaryAction: {
            signStore.refreshToken { isSuccess in
                if isSuccess {
                    userService.getUserInfo()
                    userInfoStore.performSetSignType()
                    path.append(PathType.home)
                }
            }
        }, secondaryAction: {
            DispatchQueue.main.async {
                guard let appleID = Bundle.main.object(forInfoDictionaryKey: "Apple_Id") as? String else {
                    return
                }

                let modifiedAppleID = appleID.replacingOccurrences(of: "apple", with: "").trimmingCharacters(in: .whitespaces)

                guard let url = URL(string: "itms-apps://itunes.apple.com/app/\(modifiedAppleID)"),
                      UIApplication.shared.canOpenURL(url) else {
                    return
                }

                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        .onAppear {
            categoryStore.fetchCategories()
            performVersionChecking()
        }
    }
}

extension ContentView {
    private func performVersionChecking() {
        versionService.verifyVersion { isForceUpdateRequired, isLatest  in
            if isLatest { // 최신버전
                guard KeychainService.shared.getSachosaengRefreshToken() != nil else { return }
                signStore.refreshToken { isSuccess in
                    if isSuccess {
                        userService.getUserInfo()
                        userInfoStore.performSetSignType()
                        path.append(PathType.home)
                    }
                }
            } else { // 최신버전이 아님
                if isForceUpdateRequired { // 최신버전 아닌데 필수 업데이트도 안함
                    isPopUpType = .forceUpdate
                    isPopUpView = true
                } else { // 최신 버전은 아닌데 필수 업데이트는 함
                    isPopUpType = .latestVersion
                    isPopUpView = true
                }
            }
        }
    }
}
