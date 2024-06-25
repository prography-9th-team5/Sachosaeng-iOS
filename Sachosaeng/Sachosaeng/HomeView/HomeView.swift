//
//  HomeView.swift
//  Sachosaeng
//
//  Created by LJh on 6/24/24.
//

import SwiftUI

struct HomeView: View {
    @State var categoryName: String = "전체"
    @State var isSheet: Bool = false
    private var categoryButtonName: String = "카테고리 변경"
    
    var body: some View {
        TabView {
            NavigationStack {
                VStack(spacing: 0) {
                    HStack {
                        Text(categoryName)
                            .font(.createFont(weight: .bold, size: 26))
                            .padding(.trailing, 12)
                        Button {
                            isSheet = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                        .fill(CustomColor.GrayScaleColor.gs3)
                                        .frame(width: 102, height: 30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(CustomColor.GrayScaleColor.gs4, lineWidth: 1)
                                        )
                                
                                Text(categoryButtonName)
                                    .font(.createFont(weight: .medium, size: 14))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                            }
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            Image("Progressbaricon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    } //: Hstack
                    .padding(.all, 20)
                    
                    ScrollView {
                        VoteListCellView(titleName: "# 인기 투표")
                            .padding(.bottom, 36)
                        VoteListCellView(titleName: "# 경조사 투표")
                            .padding(.bottom, 36)
                        VoteListCellView(titleName: "# 전화 통화 투표")
                            .padding(.bottom, 36)
                    } //: ScrollView
                }
            }
            .sheet(isPresented: $isSheet, content: {
                GeometryReader { geometry in
                    CategoryModal()
                        .cornerRadius(12)
                        .presentationDetents([.height(520), .height(520)])
                        
                }
            })

        }
    }
}

#Preview {
    HomeView()
}
