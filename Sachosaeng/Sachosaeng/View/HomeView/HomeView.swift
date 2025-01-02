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
    @State private var isShowDaily: Bool = false
    @State private var isRegistration: Bool = false
    @State private var isTouchedVoteIndex: Int?
    
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
                    
//                    Button {
//                        path.append(PathType.myPage)
//                    } label: {
//                        Image("온보딩_\(userInStore.currentUserState.userType)")
//                            .resizable()
//                            .scaledToFit()
//                            .clipShape(Circle())
//                            .frame(width: 40, height: 40)
//                    }
                } //: Hstack
                .padding(.all, 20)
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        if voteStore.categoryName == "카테고리" {
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
                                
//                                VStack(spacing: 0) {
//                                    
//                                }
//                                .padding(.bottom, 32)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 0) {
                                        ForEach(Array(voteStore.hotVotes.votes.enumerated()), id: \.element) { index, vote in
                                            Button {
                                                if isTouchedVoteIndex == nil {
                                                    isTouchedVoteIndex = vote.voteId
                                                    path.append(PathType.voteDetail(vote.voteId))
                                                }
                                            } label: {
                                                // MARK: - 작업중

                                                setHotVoteCell(vote: vote, index: index)
                                                    .padding(.trailing, 8)
                                            }
                                            .onAppear {
                                                isTouchedVoteIndex = nil
                                            }
                                        }
                                    }
                                    
                                }
                                .padding(.leading, 20)
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
                                                Button {
                                                    if isTouchedVoteIndex == nil {
                                                        isTouchedVoteIndex = vote.voteId
                                                        path.append(PathType.voteDetail(vote.voteId))
                                                    }
                                                } label: {
                                                    setHotVoteWithCategory(vote: vote)
                                                        .padding(.bottom, 6)
                                                }
                                                .onAppear {
                                                    isTouchedVoteIndex = nil
                                                }
                                            }
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
                                    Button {
                                        if isTouchedVoteIndex == nil {
                                            isTouchedVoteIndex = vote.voteId
                                            path.append(PathType.voteDetail(vote.voteId))
                                        }
                                    } label: {
                                        setHotVoteCellInCategory(vote: vote, index: index)
                                            .padding(.horizontal, 20)
                                            .padding(.bottom, 6)
                                    }
                                    .onAppear {
                                        isTouchedVoteIndex = nil
                                    }
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
//                                    VoteCellWithOutIndex(voteStore: voteStore, bookmarkStore: bookmarkStore, vote: vote)
//                                        
//
                                    Button {
                                        if isTouchedVoteIndex == nil {
                                            isTouchedVoteIndex = vote.voteId
                                            path.append(PathType.voteDetail(vote.voteId))
                                        }
                                    } label: {
                                        setVoteCell(vote: vote)
                                            .padding(.horizontal, 20)
                                            .padding(.bottom, 6)
                                    }
                                    .onAppear {
                                        isTouchedVoteIndex = nil
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
                                if voteStore.categoryName == "카테고리" {
                                
                                } else {
                                    withAnimation {
                                        proxy.scrollTo("top")
                                    }
                                }
                            }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                Button {
                    isRegistration = true
                } label: {
                    HStack(spacing: 0) {
                        Image("stampImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 19, height: 19)
                            .padding(.leading, 20)
                            .padding(.trailing, 6)
                        
                        Text("투표 등록")
                            .font(.createFont(weight: .bold, size: 14))
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .padding(.trailing, 20)
                    }
                    .frame(height: 40)
                    .background(CustomColor.GrayScaleColor.gs6)
                    .cornerRadius(20, corners: .allCorners)
                }
                .padding(.bottom, 12)
            }
            if isSheet {
                CustomColor.GrayScaleColor.black.ignoresSafeArea()
                    .opacity(0.7)
            }
            
        }
        .showPopupView(isPresented: $isShowDaily, message: .dailyVote, primaryAction: {
            tabBarStore.isOpacity = true
        }, secondaryAction: {
            tabBarStore.isOpacity = false
            path.append(PathType.daily)
        })
        .showPopupView(isPresented: $isRegistration, message: .registration, primaryAction: {
            tabBarStore.isOpacity = true
        }, secondaryAction: {
            tabBarStore.isOpacity = false
            path.append(PathType.voteRegistration)
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
                if voteStore.categoryName != "카테고리" {
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
    @ViewBuilder
    private func setHotVoteCellInCategory(vote: VoteWithoutCategory, index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 60)
                .foregroundStyle(vote.isVoted ? CustomColor.GrayScaleColor.gs3 : CustomColor.GrayScaleColor.white)

            HStack(spacing: 0) {
                if vote.isVoted {
                    Image("checkCircle")
                        .circleImage(frame: 16)
                        .padding(.leading, 16)
                } else {
                    Text("\(index + 1)")
                        .font(.createFont(weight: .bold, size: 15))
                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                        .padding(.leading, 16)
                }
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(vote.title)
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .lineLimit(1)
                        Spacer()
                    }
                    
                    HStack(spacing : 0) {
                        if let participantCount = vote.participantCount, participantCount > 10 {
                            HStack(spacing: 0) {
                                Text("\(participantCount)명 참여 중")
                                    .font(.createFont(weight: .medium, size: 12))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.leading, 10)
            }
        }
    }
    @ViewBuilder
    private func setVoteCell(vote: VoteWithoutCategory) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 60)
                .foregroundStyle(vote.isVoted ? CustomColor.GrayScaleColor.gs3 : CustomColor.GrayScaleColor.white)
            
            HStack(spacing: 0) {
                if vote.isVoted {
                    Image("checkCircle_true")
                        .circleImage(frame: 16)
                        .padding(.leading, 16)
                }
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text(vote.title)
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .lineLimit(1)
                        Spacer()
                    }
                    if let participantCount = vote.participantCount, participantCount > 10 {
                        HStack(spacing: 0) {
                            Text("\(participantCount)명 참여 중")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                            Spacer()
                        }
                    }
                }
                .padding(.leading, 10)
            }
        }
    }
    @ViewBuilder
    private func setHotVoteWithCategory(vote: VoteWithoutCategory) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 60)
                .foregroundStyle(vote.isVoted ? CustomColor.GrayScaleColor.gs3 : CustomColor.GrayScaleColor.white)
            
            HStack(spacing: 0) {
                if vote.isVoted {
                    Image("checkCircle_true")
                        .circleImage(frame: 16)
                        .padding(.leading, 16)
                }
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text(vote.title)
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .lineLimit(1)
                        Spacer()
                    }
                    if let participantCount = vote.participantCount, participantCount > 10 {
                        HStack(spacing: 0) {
                            Text("\(participantCount)명 참여 중")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                            Spacer()
                        }
                    }
                }
                .padding(.leading, 10)
            }
        }
    }
    
    @ViewBuilder
    private func setHotVoteCell(vote: Vote, index: Int) -> some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 8)
//                .frame(height: 60)
//                .foregroundStyle(vote.isVoted ? CustomColor.GrayScaleColor.gs3 : CustomColor.GrayScaleColor.white)
//            HStack(spacing: 0) {
//                if vote.isVoted {
//                    Image("checkCircle_true")
//                        .circleImage(frame: 16)
//                        .padding(.leading, 16)
//                } else {
//                    Text("\(index + 1)")
//                        .font(.createFont(weight: .bold, size: 15))
//                        .foregroundStyle(CustomColor.GrayScaleColor.black)
//                        .padding(.leading, 16)
//                }
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            if let participantCount = vote.participantCount, participantCount > 10 {
                                Text("\(participantCount)명 참여 중")
                                    .font(.createFont(weight: .medium, size: 12))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                    
                            }
                            Spacer()
                        }
                        
                        
                        HStack(spacing: 0) {
                            Text(vote.title)
                                .font(.createFont(weight: .semiBold, size: 15))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    .padding(.top, 20)
                    .padding(.leading, 16)
                    
                    Spacer()

                    HStack(spacing: 0) {
                        Spacer()
                        AsyncImage(url: URL(string: vote.category.iconUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(16)
                    }
                }
                .background(Color(hex: vote.category.backgroundColor))
                .cornerRadius(8, corners: .allCorners)
                .frame(width: 156, height: 176)

//                ZStack {
//                    RoundedRectangle(cornerRadius: 4)
//                        .frame(width: 32, height: 32)
//                        .foregroundStyle(Color(hex: vote.category.backgroundColor))
                    
                  
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.bottom, 6)
    }
}
