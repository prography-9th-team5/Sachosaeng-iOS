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
                            MyPageView(isSign: $isSign, path: $path)
                                .customBackbutton {
                                    myLogPrint("""
                                          😿 네비게이션 패스의 갯수: \(path.count)
                                          😿 네비게이션 패스: \(path)
                                          """, isTest: true)
                                }
                        } else if name == "EditMyInfoView" {
                            EditMyInfoView(isSign: $isSign, path: $path)
                                .customBackbutton {
                                    myLogPrint("""
                                          😿 네비게이션 패스의 갯수: \(path.count)
                                          😿 네비게이션 패스: \(path)
                                          """, isTest: true)
                                }
                        } else if name == "QuitView" {
                            QuitView(isSign: $isSign, path: $path)
                                .customBackbutton {
                                    myLogPrint("""
                                          😿 네비게이션 패스의 갯수: \(path.count)
                                          😿 네비게이션 패스: \(path)
                                          """, isTest: true)
                                }
                        } else if name == "SignView" {
                            SignView(path: $path, isSign: $isSign)
                                .customBackbutton {
                                    myLogPrint("""
                                          😿 네비게이션 패스의 갯수: \(path.count)
                                          😿 네비게이션 패스: \(path)
                                          """, isTest: true)
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
                            VoteListCellView(votes: voteStore.hotVotes.votes)
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
        HomeView(isSign: .constant(false), path: .constant(NavigationPath()), categoryStore: CategoryStore(), voteStore: VoteStore())
    }
}
