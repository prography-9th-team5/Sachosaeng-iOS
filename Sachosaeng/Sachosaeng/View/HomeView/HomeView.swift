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
    @State private var categoryName: String = "전체"
    @State private var isSheet: Bool = false
    private let isTest: Bool = false
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
                        CategoryModal(categoryStore: categoryStore)
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
                            TodayVoteView(dailyVote: voteStore.dailyVote)
                                .padding(.bottom, 32)
                                .id("top")
                            
                            //                            HotvoteListView(
                            //                                hotVote: voteStore.hotVotes)
                            //                            .padding(.bottom, 32)
                            
                            //                            VoteListCellView(titleName: "# 경조사 투표", isFavoriteVote: false)
                            //                                .padding(.bottom, 32)
                            //                            VoteListCellView(titleName: "# 전화 통화 투표", isFavoriteVote: false)
                            //                                .padding(.bottom, 32)
                            Spacer()
                        } else {
                            //                            VoteListCellView(titleName: "", isFavoriteVote: false)
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
                await voteStore.fetchDaily()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(isSign: .constant(false), path: .constant(NavigationPath()), categoryStore: CategoryStore(), voteStore: VoteStore())
    }
}
