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
    @ObservedObject var categoryStore = CategoryStore()
    @ObservedObject var voteStore: VoteStore = VoteStore()
    var body: some View {
        VStack(spacing: 0) {
            switch switchTab {
                case .home:
                    HomeView(isSign: $isSign, path: $path, categoryStore: categoryStore, voteStore: voteStore)
                        .navigationBarBackButtonHidden()
                case .bookMark:
                    BookmarkView(categoryStore: categoryStore, voteStore: voteStore)
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
        .onAppear {
            Task {
                await categoryStore.fetchCategories()
                voteStore.fetchDailyVote()
                await voteStore.fetchHotVotes()
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    TabView(isSign: .constant(false), path: .constant(NavigationPath()))
}
