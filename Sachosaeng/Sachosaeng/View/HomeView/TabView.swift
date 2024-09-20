//
//  MainView.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

enum TabItem {
    case home
    case bookMark
}

struct TabView: View {
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @State var switchTab: TabItem = .home
    @State private var isPopup: Bool = false
    @StateObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @StateObject var bookmarkStore: BookmarkStore
    var body: some View {
        VStack(spacing: 0) {
            switch switchTab {
                case .home:
                    HomeView(isSign: $isSign, path: $path, categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore)
                        .navigationBarBackButtonHidden()
                        
                case .bookMark:
                    BookmarkView(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore)
            }
            
            ZStack {
                CustomColor.GrayScaleColor.gs4
                HStack(spacing: 0) {
                    Spacer()
                    Button {
                        switchTab = .home
                    } label: {
                        Image(switchTab == .home ? "HomeTab" : "HomeTab_off")
                    }
                    .padding(.bottom, 30)
                    .padding(.top, 18)
                    
                    Spacer()

                    Button {
                        switchTab = .bookMark
                    } label: {
                        Image(switchTab == .bookMark ? "bookmark" : "bookmark_off")
                            .foregroundStyle(CustomColor.GrayScaleColor.gs4)
                    }
                    .padding(.bottom, 30)
                    .padding(.top, 18)
                    Spacer()
                }
            }
            .frame(height: 76)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .background(CustomColor.GrayScaleColor.gs2)
        }
        .showPopupView(isPresented: Binding<Bool>(
            get: { !voteStore.dailyVote.isVoted },
            set: {
                newValue in voteStore.dailyVote.isVoted = !newValue
            }
        ), message: .dailyVote, primaryAction: {
            
        }, secondaryAction: {
            path.append(PathType.daily)
        })
        .onAppear {
            Task {
                categoryStore.fetchCategories()
                voteStore.fetchDailyVote()
                voteStore.fetchHotVotes()
                voteStore.fetchHotVotesInCategory()
                bookmarkStore.fetchAllVotesBookmark()
                bookmarkStore.fetchAllInformationInBookmark()
                bookmarkStore.fetchCategoriesInbookmark()
                bookmarkStore.fetchInformationCategoriesInbookmark()
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .bottom)
    }
}

