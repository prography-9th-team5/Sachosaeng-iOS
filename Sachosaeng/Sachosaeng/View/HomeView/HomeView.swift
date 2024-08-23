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
                        CategoryModal(categoryStore: categoryStore, isSheet: $isSheet, categoryName: $categoryName)
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
                            TodayVoteView(voteStore: voteStore)
                                .padding(.bottom, 32)
                                .id("top")
                            VStack {
                                PopularVoteHeaderView()
                                ForEach(Array(voteStore.hotVotes.votes.enumerated()), id: \.element) { index, vote in
                                    PopularVoteBodyView(vote: vote, index: index + 1)
                                        .padding(.horizontal, 20)
                                }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color(hex: setColorForCategory(categoryName)))
                                .frame(width: PhoneSpace.screenWidth - 40, height: 85)
                                .overlay {
                                    HStack(spacing: 0) {
                                        AsyncImage(url: URL(string: setImageForCategory(categoryName))) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                        } placeholder: {
                                            ProgressView()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                        }
                                        .padding(.trailing, 12)
                                        
                                        Text("여기다가 시간 관련 텍스트 ")
                                            .font(.createFont(weight: .bold, size: 16))
                                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    }
                                }
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

struct PopularVoteHeaderView: View {
    var body: some View {
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
    }
}

struct PopularVoteBodyView: View {
    var vote: Vote
    var index: Int
    var body: some View {
        NavigationLink {
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 60)
                    .foregroundStyle(CustomColor.GrayScaleColor.white)
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("\(index)")
                                .font(.createFont(weight: .bold, size: 15))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .padding(.trailing, 8)
                            Text(vote.title)
                                .font(.createFont(weight: .bold, size: 15))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(1)
                            Spacer()
                        }
                        
                        HStack(spacing : 0) {
                            Text("\(index)")
                                .font(.createFont(weight: .bold, size: 15))
                                .foregroundStyle(Color.clear)
                                .padding(.trailing, 8)
                            Text("\(vote.participantCount ?? 0)명 참여 중")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                        }
                    }
                    .padding(.horizontal, 16)
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color(hex: vote.category.backgroundColor))
                        AsyncImage(url: URL(string: vote.category.iconUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        } placeholder: {
                            ProgressView()
                        }
                        
                    }
                    .padding(.trailing, 16)
                }
            }
            .frame(height: 60)
            .padding(.bottom, 6)
        }
    }
}
