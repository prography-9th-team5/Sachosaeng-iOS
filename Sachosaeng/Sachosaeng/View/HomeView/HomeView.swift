//
//  HomeView.swift
//  Sachosaeng
//
//  Created by LJh on 6/24/24.
//

import SwiftUI

struct HomeView: View {
    @Binding var path: NavigationPath
    @StateObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @State var categoryName: String = "전체"
    @State var isSheet: Bool = false
    
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
                            .presentationDetents([.height(688), .height(688)])
                    }
                    
                    Spacer()
                    
                    Button {
                        path.append("MyPageView")
                    } label: {
                        Image("Progressbaricon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    .navigationDestination(for: String.self) { name in
                        if name == "MyPageView" {
                            MyPageView(path: $path)
                                .customBackbutton {
                                    print("😿 현재 코드의 위치: MypageView에서 백버튼 누름\n😿네비게이션 패스의 갯수 \(path.count)")
                                    print("😿 현재 코드의 위치: MypageView에서 백버튼 누름\n😿네비게이션 패스: \(path) \n😿")
                                }
                        } else if name == "EditMyInfoView" {
                            EditMyInfoView(path: $path)
                                .customBackbutton {
                                    print("😿 현재 코드의 위치: EditMyInfoView에서 백버튼 누름\n😿네비게이션 패스의 갯수 \(path.count)")
                                    print("😿 네비게이션 패스: \(path) \n😿")
                                }
                        }
                    }
                } //: Hstack
                .padding(.all, 20)
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        if categoryName == "전체" {
                            TodayVoteView(dailyVote: voteStore.dailyVote)
                                .padding(.bottom, 32)
                                .id("top")
                            VoteListCellView(votes: [voteStore.hotVotes.votes[0]] + [voteStore.dailyVote])
                                .padding(.bottom, 32)
                            
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
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(path: .constant(NavigationPath()), categoryStore: CategoryStore(), voteStore: VoteStore())
    }
}
