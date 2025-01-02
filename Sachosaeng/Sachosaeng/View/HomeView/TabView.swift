//
//  MainView.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI
import FirebaseAnalytics

struct TabView: View {
    @ObservedObject var categoryStore: CategoryStore
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    @EnvironmentObject var tabBarStore: TabBarStore
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @State private var isPopup: Bool = false
    @State private var toast: Toast?
    var body: some View {
        VStack(spacing: 0) {
            switch tabBarStore.switchTab {
            case .home:
                HomeView(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore, isSign: $isSign, path: $path)
                .navigationBarBackButtonHidden()
                .onAppear {
                    if tabBarStore.switchTab != .home {
                        tabBarStore.switchTab = .home
                    }
                }
                    
            case .bookMark, .edit:
                BookmarkView(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore, path: $path)
                .onAppear {
                    if tabBarStore.switchTab != .bookMark {
                        tabBarStore.switchTab = .bookMark
                    }
                }
                .showToastView(toast: $toast)
            }
            
            ZStack {
                if tabBarStore.switchTab == .edit {
                    CustomColor.GrayScaleColor.gs2
                    BookmarkDeleteView(bookmarkStore: bookmarkStore, selectedButton: $bookmarkStore.selectedButton, isEdit: $bookmarkStore.isEditBookMark, toast: $toast)
                        .padding(.bottom, 20)
                } else {
                    CustomColor.GrayScaleColor.gs4
                    HStack(spacing: 0) {
                        Spacer()
                        Button {
                            tabBarStore.switchTab = .home
                        } label: {
                            Image(tabBarStore.switchTab == .home ? "HomeTab" : "HomeTab_off")
                        }
                        .padding(.bottom, 30)
                        .padding(.top, 18)
                        
                        Spacer()
                        
                        Button {
                            tabBarStore.switchTab = .bookMark
                        } label: {
                            Image(tabBarStore.switchTab == .bookMark ? "bookmark" : "bookmark_off")
                                .foregroundStyle(CustomColor.GrayScaleColor.gs4)
                        }
                        .padding(.bottom, 30)
                        .padding(.top, 18)
                        Spacer()
                    }
                }
            }
            .frame(height: 76)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .background(CustomColor.GrayScaleColor.gs2)
            .overlay {
                if tabBarStore.isOpacity {
                    ZStack {
                        Rectangle()
                            .fill(CustomColor.GrayScaleColor.black.opacity(0.7))
                            .ignoresSafeArea()
                    }
                }
            }
        }
        .onAppear {
            Task {
                UserService.shared.getUserInfo()
                UserService.shared.getUserCategories()
                voteStore.fetchHotVotes()
                voteStore.fetchHotVotesInCategory()
                categoryStore.fetchCategories()
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
