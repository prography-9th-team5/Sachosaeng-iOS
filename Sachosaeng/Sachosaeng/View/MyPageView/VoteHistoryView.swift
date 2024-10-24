//
//  VoteHistoryView.swift
//  Sachosaeng
//
//  Created by LJh on 10/24/24.
//

import SwiftUI

struct VoteHistoryView: View {
    @ObservedObject var voteStore: VoteStore
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView {
                    Button {
                        path.append(PathType.registeredVotes)
                    } label: {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Text("투표 제목")
                                    .font(.createFont(weight: .bold, size: 14))
                                    .foregroundStyle(CustomColor.GrayScaleColor.black)
                                Spacer()
                            }
                            .padding(.bottom, 14)
                            HStack(spacing: 0) {
                                Image("history_APPROVED")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 8, height: 8)
                                    .padding(.trailing, 4)
                                Text("투표 등록 실패")
                                    .font(.createFont(weight: .medium, size: 12))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                Spacer()
                            }
                        }
                        .padding(16)
                        .frame(width: PhoneSpace.screenWidth - 40, height: 66)
                        .background(CustomColor.GrayScaleColor.white)
                        .cornerRadius(8, corners: .allCorners)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("투표 등록 히스토리")
        .navigationBarTitleTextColor(CustomColor.GrayScaleColor.gs6, .medium, size: 18)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            voteStore.fetchHistory(cursor: 0, size: 10)
        }
    }
}

struct RegisteredVotesView: View {
    @State private var choiceTextArray: [String] = ["123", "456", "789", "123"]

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
                            Text("투표 제목을 작성해 주세요투표 제목을 작성해 주세요투표 제목을 작성해 주세요투표 제목을 작성해 주세요투표 제목을 작성해 주세요")
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
                        ForEach(choiceTextArray, id: \.self) { text in
                            HStack(spacing: 0) {
                                Text(text)
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
                    
                    VStack(spacing: 0) {
                        titleView(titleString: "카테고리")
                            .padding(.bottom, 12)
                        ForEach(CategoryStore().categories) { category in
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
                        }
                    }

                }
            }
            .padding()
        }
    }
}

extension RegisteredVotesView {
    @ViewBuilder
    private func titleView(titleString: String) -> some View {
        HStack(spacing: 0) {
            Text(titleString)
                .font(.createFont(weight: .semiBold, size: 15))
                .foregroundStyle(CustomColor.GrayScaleColor.black)
            Spacer()
        }
    }
}
