//
//  HomeView.swift
//  Sachosaeng
//
//  Created by LJh on 6/24/24.
//

import SwiftUI

struct HomeView: View {
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @StateObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @ObservedObject var userStore = UserStore.shared
    @State var categoryName: String = "전체"
    @State private var isSheet: Bool = false
    
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(categoryName)
                        .font(.createFont(weight: .bold, size: 26))
                        .padding(.trailing, 7)
                    Button {
                        isSheet = true
                    } label: {
                        Image("CategoryIcon")
                            .font(.createFont(weight: .medium, size: 14))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                    }
                    .sheet(isPresented: $isSheet) {
                        CategoryModal(categoryStore: categoryStore, voteStore: voteStore, isSheet: $isSheet, categoryName: $categoryName)
                            .cornerRadius(12)
                            .presentationDetents([.height(PhoneSpace.screenHeight - 150)])
                    }
                    
                    Spacer()
                    
                    Button {
                        path.append(PathType.myPage)
                    } label: {
                        Image("온보딩_\(userStore.currentUserState.userType)")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    }
                } //: Hstack
                .padding(.all, 20)
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        if categoryName == "전체" {
                            TodayVoteCell(voteStore: voteStore)
                                .padding(.bottom, 32)
                                .id("top")
                            VStack(spacing: 0) {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Image("FavoriteVoteIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18, height: 18)
                                            .padding(.trailing, 6)
                                        
                                        Text("인기 투표")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(CustomColor.GrayScaleColor.gs6)
                                        Spacer()
                                    }
                                    .padding(.bottom, 12)
                                }
                                .padding(.horizontal, 20)
                                ForEach(Array(voteStore.hotVotes.votes.enumerated()), id: \.element) { index, vote in
                                    PopularVoteCell(vote: vote, voteStore: voteStore, index: index + 1)
                                        .padding(.horizontal, 20)
                                }
                            }
                        } else {
                            VStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(hex: voteStore.hotVotesWithCategory.category.backgroundColor))
                                    .frame(width: PhoneSpace.screenWidth - 40, height: 85)
                                    .overlay {
                                        HStack(spacing: 0) {
                                            AsyncImage(url: URL(string: setImageForCategory(categoryName))) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width:  32, height: 32)
                                            } placeholder: {
                                                ProgressView()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                            }
                                            .padding(.trailing, 12)
                                            
                                            Text(voteStore.hotVotesWithCategory.description)
                                                .font(.createFont(weight: .bold, size: 16))
                                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                        }
                                    }
                                    .padding(.bottom, 12)
                                
                                ForEach(Array(voteStore.hotVotesWithCategory.votes.enumerated()), id: \.element) { index, vote  in
                                    
                                    PopularVoteWithCategoryCell(voteStore: voteStore, vote: vote, index: index + 1)
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 6)
                                }
                                
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("최신순")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(CustomColor.GrayScaleColor.gs6)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .padding(.top, 30)
                                .padding(.bottom, 14)
                            } //: Vstack
                        }
                    } //: ScrollView
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            withAnimation {
                                proxy.scrollTo("top")
                            }
                        } label: {
                            Image("Floating button")
                        }
                    }
                }
            }
            if isSheet {
                CustomColor.GrayScaleColor.black.ignoresSafeArea()
                    .opacity(0.7)
            }
        }
        .onAppear {
            Task {
                voteStore.fetchDailyVote()
                voteStore.fetchHotVotes()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(isSign: .constant(false), path: .constant(NavigationPath()), categoryStore: CategoryStore(), voteStore: VoteStore())
    }
}

extension HomeView {
    private func setColorForCategory(_ categoryName: String) -> String {
        if let matchedCategory = categoryStore.categories.first(where: { $0.name == categoryName }) {
            return matchedCategory.backgroundColor
        }
        return "#FFFFFF"
    }
    
    private func setImageForCategory(_ categoryName: String) -> String {
        if let matchedCategory = categoryStore.categories.first(where: { $0.name == categoryName }) {
            return matchedCategory.iconUrl
        }
        return ""
    }
    
}

