//
//  RegisteredVotesView.swift
//  Sachosaeng
//
//  Created by LJh on 10/25/24.
//

import SwiftUI

struct RegisteredVoteView: View {
    @ObservedObject var voteStore: VoteStore
    @Binding var path: NavigationPath
    @State var voteId: Int
    
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    HStack(spacing: 0) {
                        Text("투표가 등록되었어요! 추가된 투표에 참여해 보세요.")
                            .font(.createFont(weight: .medium, size: 12))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                        Spacer()
                    }
                    .padding(.bottom, 25)
                    
                    VStack(spacing: 0) {
                        titleView(titleString: "투표 제목")
                            .padding(.bottom, 12)
                        HStack(spacing: 0) {
                            Text(voteStore.currentRegisteredVote.title)
                                .font(.createFont(weight: .medium, size: 12))
                            Spacer()
                        }
                        .padding(16)
                        .background(CustomColor.GrayScaleColor.white)
                        .cornerRadius(8, corners: .allCorners)
                    }
                    .padding(.bottom, 36)
                    
                    VStack(spacing: 0) {
                        titleView(titleString: "선택지")
                            .padding(.bottom, 12)
                        ForEach(voteStore.currentRegisteredVote.voteOptions.indices, id: \.self) { index in
                            HStack(spacing: 0) {
                                Text(voteStore.currentRegisteredVote.voteOptions[index])
                                    .font(.createFont(weight: .medium, size: 12))
                                Spacer()
                            }
                            .padding(16)
                            .background(CustomColor.GrayScaleColor.white)
                            .cornerRadius(8, corners: .allCorners)
                            .padding(.bottom, 8)
                        }
                    }
                    .padding(.bottom, 36)
                    
                    LazyVStack(spacing: 0) {
                        titleView(titleString: "카테고리")
                            .padding(.bottom, 12)
                        ForEach(voteStore.currentRegisteredVote.categories.chunked(into: 3), id: \.self) { rowCategories in
                            HStack(spacing: 0) {
                                ForEach(rowCategories) { category in
                                    HStack(spacing: 0) {
                                        AsyncImage(url: URL(string: category.iconUrl)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 18, height: 18)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .padding(.trailing, 8)
                                        
                                        Text(category.name)
                                            .font(.createFont(weight: .medium, size: 12))
                                            .foregroundStyle(Color(hex: category.textColor))
                                    }
                                    .padding(.horizontal, 12)
                                    .frame(height: 36)
                                    .background(Color(hex: category.backgroundColor))
                                    .cornerRadius(4, corners: .allCorners)
                                    .padding(.trailing, 8)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 8)
                        }
                    }
                    .padding(.bottom, 27)
                }
                if voteStore.currentRegisteredVote.status == HistoryType.approved.rawValue {
                    Button {
                        path.append(PathType.home)
                        path.append(PathType.voteDetail(voteId))
                    } label: {
                        Text("투표하러 가기")
                            .font(.createFont(weight: .medium, size: 16))
                            .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .background(CustomColor.GrayScaleColor.black)
                            .cornerRadius(4)
                    }
                } 
            }
            .padding()
        }
        .onAppear {
            voteStore.fetchRegisteredVote(voteId: voteId)
        }
    }
}

extension RegisteredVoteView {
    @ViewBuilder
    private func titleView(titleString: String) -> some View {
        HStack(spacing: 0) {
            Text(titleString)
                .font(.createFont(weight: .semiBold, size: 15))
                .foregroundStyle(CustomColor.GrayScaleColor.black)
            Spacer()
            if titleString == "선택지" {
                Text(voteStore.currentRegisteredVote.isMultipleChoiceAllowed ? "복수 선택 가능" : "")
                    .font(.createFont(weight: .medium, size: 12))
                    .foregroundStyle(CustomColor.GrayScaleColor.gs5)
            }
        }
    }
}
