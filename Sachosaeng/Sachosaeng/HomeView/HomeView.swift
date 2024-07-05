//
//  HomeView.swift
//  Sachosaeng
//
//  Created by LJh on 6/24/24.
//
// TODO: 카테고리 변경 후 바뀌는거 작업해야함
import SwiftUI

//enum Category {
//    
//}

struct HomeView: View {
    @State var path = NavigationPath()
    @State var categoryName: String = "전체"
    @State var isSheet: Bool = false
    private var categoryButtonName: String = "카테고리 변경"
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {            
                CustomColor.GrayScaleColor.gs2.edgesIgnoringSafeArea(.all)
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
                        .sheet(isPresented: $isSheet, content: {	
                            GeometryReader { geometry in
                                CategoryModal()
                                    .cornerRadius(12)
                                    .presentationDetents([.height(688), .height(688)])
                            }
                        })
                        
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
    //                        if name == "FAQ" {
    //                            testView(path: $path)
    //                        }
                            if name == "MyPageView" {
                                MyPageView(path: $path)
                            }
                        }
                        
                    } //: Hstack
                    .padding(.all, 20)
                    
                    if categoryName == "전체" {
                        ScrollView(showsIndicators: false) {
                            TodayVoteView()
                                .padding(.bottom, 32)
                            VoteListCellView(titleName: "# 인기 투표", isFavoriteVote: true)
                                .padding(.bottom, 36)
                            VoteListCellView(titleName: "# 경조사 투표", isFavoriteVote: false)
                                .padding(.bottom, 36)
                            VoteListCellView(titleName: "# 전화 통화 투표", isFavoriteVote: false)
                                .padding(.bottom, 36)
                            Spacer()
                        } //: ScrollView
                    } else {
                        ScrollView(showsIndicators: false) {
                            VoteListCellView(titleName: "", isFavoriteVote: false)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
