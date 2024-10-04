//
//  HomeView.swift
//  Sachosaeng
//
//  Created by LJh on 6/24/24.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var categoryStore: CategoryStore
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    @EnvironmentObject var tabBarStore: TabBarStore
    @EnvironmentObject var userInStore: UserInfoStore
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @State private var isSheet: Bool = false
    @State var isShowDaily: Bool = false
    @State private var isTouched = false

    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(voteStore.categoryName)
                        .font(.createFont(weight: .bold, size: 26))
                        .padding(.trailing, 7)
                    Button {
                        isSheet = true
                    } label: {
                        Image("CategoryIcon")
                            .font(.createFont(weight: .medium, size: 14))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                    }
                    
                    Spacer()
                    
                    Button {
                        path.append(PathType.myPage)
                    } label: {
                        Image("온보딩_\(userInStore.currentUserState.userType)")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    }
                } //: Hstack
                .padding(.all, 20)
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        if voteStore.categoryName == "전체" {
                            DailyVoteCell(voteStore: voteStore, bookmarkStore: bookmarkStore)
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
                                
                                // 인기투표 3종이 나오는것
                                VStack(spacing: 0) {
                                    ForEach(Array(voteStore.hotVotes.votes.enumerated()), id: \.element) { index, vote in
                                        HotVoteCell(voteStore: voteStore, bookmarkStore: bookmarkStore, vote: vote, index: index + 1)
                                            .padding(.horizontal, 20)
                                    }
                                }
                                .padding(.bottom, 32)
                                
                                ForEach(voteStore.hotVotesInCategory) { hotVote in
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            AsyncImage(url: URL(string: hotVote.category.iconUrl)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 18, height: 18)
                                                    .padding(.trailing, 6)
                                            } placeholder: {
                                                ProgressView()
                                                    .scaledToFit()
                                                    .frame(width: 18, height: 18)
                                                    .padding(.trailing, 6)
                                            }
                                            
                                            Text(hotVote.category.name)
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(Color(hex: hotVote.category.textColor))
                                            Spacer()
                                        }
                                        .padding(.bottom, 12)
                                        
                                        if let categorizedVote = voteStore.hotVotesInCategory.first(where: { $0.category.id == hotVote.category.categoryId }) {
                                            
                                            ForEach(categorizedVote.votes) { vote in
                                                VoteCellWithOutIndex(voteStore: voteStore, bookmarkStore: bookmarkStore, vote: vote)
                                                    .padding(.bottom, 6)
                                            }
                                        } else {
                                            Text("투표가 없는뎅 ㅠㅠ ")
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 32)
                            }
                        } else {
                            // MARK: - 사용자가 카테고리를 선택했을 때 플로우
                            LazyVStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(hex: voteStore.hotVotesWithSelectedCategory.category.backgroundColor))
                                    .frame(width: PhoneSpace.screenWidth - 40, height: 85)
                                    .id("top")
                                    .overlay {
                                        HStack(spacing: 0) {
                                            AsyncImage(url: URL(string: setImageForCategory(voteStore.categoryName))) { image in
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
                                            
                                            Text(voteStore.hotVotesWithSelectedCategory.description ?? "없을수도 있지")
                                                .font(.createFont(weight: .bold, size: 16))
                                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                        }
                                    }
                                    .padding(.bottom, 12)
                                
                                ForEach(Array(voteStore.hotVotesWithSelectedCategory.votes.enumerated()), id: \.element) { index, vote  in
                                    VoteCell(voteStore: voteStore, bookmarkStore: bookmarkStore, vote: vote, index: index + 1)
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
                                
                                ForEach(voteStore.latestVotes.votes) { vote in
                                    VoteCellWithOutIndex(voteStore: voteStore, bookmarkStore: bookmarkStore, vote: vote)
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 6)
                                        .onAppear {
                                            if vote == voteStore.latestVotes.votes.last {
                                                if voteStore.latestVotes.hasNext {
                                                    voteStore.fetchLatestVoteWithCursor(categoryId: voteStore.categoryID(voteStore.categoryName))
                                                }
                                            }
                                        }
                                }
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
                    .sheet(isPresented: $isSheet) {
                        CategoryModal(voteStore: voteStore,
                                      categoryStore: categoryStore,
                                      isSheet: $isSheet, categoryName: $voteStore.categoryName)
                            .cornerRadius(12)
                            .presentationDetents([.height(PhoneSpace.screenHeight - 150)])
                            .onDisappear {
                                if voteStore.categoryName == "전체" {
                                
                                } else {
                                    withAnimation {
                                        proxy.scrollTo("top")
                                    }
                                }
                            }
                    }
                }
            }
            if isSheet {
                CustomColor.GrayScaleColor.black.ignoresSafeArea()
                    .opacity(0.7)
            }
            
        }
        .showPopupView(isPresented: $isShowDaily, message: .dailyVote, primaryAction: {
            tabBarStore.isOpacity = true
        }, secondaryAction: {
            path.append(PathType.daily)
        })
        .onAppear {
            ViewTracker.shared.updateCurrentView(to: .home)
            ViewTracker.shared.currentTap = .home
            AnalyticsService.shared.trackView("HomeView")
            Task {
                voteStore.fetchDailyVote() { isVoted in
                    isShowDaily = !isVoted
                }
                let categoryId = voteStore.categoryID(voteStore.categoryName)
                if voteStore.categoryName != "전체" {
                    voteStore.fetchHotVotesWithSelectedCategory(categoryId: categoryId)
                }
                voteStore.fetchLatestVotesInSelectedCategory(categoryId: categoryId)
            }
            
        }
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

struct DisableMultiTouch: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isMultipleTouchEnabled = false  // 다중 터치 비활성화
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
