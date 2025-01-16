//
//  TodayVoteView.swift
//  Sachosaeng
//
//  Created by LJh on 6/27/24.
//

import SwiftUI

struct DailyVoteCell: View {
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore

    var body: some View {
        NavigationLink {
            VoteDetailView(voteStore: voteStore, bookmarkStore: bookmarkStore, voteId: voteStore.dailyVote.voteId)
        } label: {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("오늘의 투표")
                            .font(.createFont(weight: .medium, size: 12))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs3)
                            .frame(width: 69, height: 24)
                            .background(CustomColor.GrayScaleColor.gs6)
                            .cornerRadius(20, corners: .allCorners)
                            .padding(.bottom, 10)
                            .padding(.top, 16)
                        Spacer()
                    }
                    
                    HStack(spacing: 0) {
                        Text(voteStore.dailyVote.title)
                            .font(.createFont(weight: .bold, size: 16))
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .padding(.bottom, 18)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
    
                if voteStore.isVotedDailyVote {
                    VStack(spacing: 0) {
                        let totalVotes = voteStore.currentVoteDetail.voteOptions.reduce(0) { $0 + $1.count }
                        let maxVoteCount = voteStore.currentVoteDetail.voteOptions.map { $0.count }.max() ?? 0
                        let categoryColor = voteStore.currentVoteDetail.category.backgroundColor
                        let categoryTextColor = voteStore.currentVoteDetail.category.textColor
                        
                        ForEach(voteStore.currentVoteDetail.voteOptions) { voteOption in
                            let votePercentage = totalVotes > 0 ? Double(voteOption.count) / Double(totalVotes) : 0
                            let isHighestVote = voteOption.count == maxVoteCount
                            ZStack {
                                HStack(spacing: 0) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(CustomColor.GrayScaleColor.gs6, lineWidth: 0)
                                        .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                        .background(isHighestVote ? Color(hex: categoryColor) : CustomColor.GrayScaleColor.gs6)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                    Spacer()
                                }
                                
                                HStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(isHighestVote ? Color(hex: voteStore.currentVoteDetail.category.backgroundColor) : CustomColor.GrayScaleColor.gs4)
                                        .frame(width: (PhoneSpace.screenWidth - 80) * votePercentage, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        
                                        .animation(.easeInOut(duration: 0.8), value: votePercentage)

                                    Spacer()
                                }
                                
                                HStack {
                                    Text("\(voteOption.content)")
                                        .foregroundStyle(isHighestVote ? Color(hex: categoryTextColor) : CustomColor.GrayScaleColor.white)
                                        .padding(.leading, 16)
                                        .font(.createFont(weight: .bold, size: 14))
                                    Spacer()
                                    Text("\(Int(votePercentage * 100))%")
                                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                                        .padding(.trailing, 16)
                                        .font(.createFont(weight: .bold, size: 14))
                                }
//                                .padding(.horizontal, 8)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                        }
                        
                    }
                } else {
                    VStack(spacing: 0) {
                        let totalVotes = voteStore.currentVoteDetail.voteOptions.reduce(0) { $0 + $1.count }
                        
                        ForEach(voteStore.currentVoteDetail.voteOptions) { voteOption in
                            let votePercentage = totalVotes > 0 ? Double(voteOption.count) / Double(totalVotes) : 0
                            ZStack {
                                HStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(CustomColor.GrayScaleColor.gs6, lineWidth: 0)
                                        .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                        .background(CustomColor.GrayScaleColor.gs6)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                    Spacer()
                                
                                }
                                HStack{
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(CustomColor.GrayScaleColor.gs4)
                                        .frame(width: (PhoneSpace.screenWidth - 80) * votePercentage, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        
                                        .animation(.easeInOut(duration: 0.8), value: votePercentage)
                                    Spacer()
                                }
                                    
                                

                                HStack {
                                    Text("\(voteOption.content)")
                                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                                        .padding(.leading, 16)
                                        .font(.createFont(weight: .bold, size: 14))
                                    Spacer()
                                    Text("\(Int(votePercentage * 100))%")
                                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                                        .padding(.trailing, 16)
                                        .font(.createFont(weight: .bold, size: 14))
                                }
//                                .padding(.horizontal, 8)
                            }
                            .padding(.leading, 16)
                            .padding(.trailing, 20)
                            .padding(.bottom, 8)
                        }
                        
                    }
                }
                HStack(spacing: 0) {
                    Text(voteStore.isVotedDailyVote ? "투표 참여 완료" : "투표 참여하기")
                        .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                        .font(.createFont(weight: .medium, size: 14))
                }
                .padding(.top, 6)
                .padding(.bottom, 18)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(CustomColor.GrayScaleColor.black)
                    .frame(width: PhoneSpace.screenWidth - 40)
            )
            .padding(.horizontal, 20)
        }
    }
}

