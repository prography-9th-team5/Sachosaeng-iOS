//
//  TodayVoteView.swift
//  Sachosaeng
//
//  Created by LJh on 6/27/24.
//

import SwiftUI

struct DailyVoteCell: View {
    @StateObject var voteStore: VoteStore
    @StateObject var bookmarkStore: BookmarkStore
    var body: some View {
        NavigationLink {
            VoteDetailView(voteId: voteStore.dailyVote.voteId, voteStore: voteStore, bookmarkStore: bookmarkStore)
        } label: {
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(CustomColor.GrayScaleColor.black)
                    .frame(width: PhoneSpace.screenWidth - 40, height: 85)
                    .overlay(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("오늘의 투표")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                                .frame(width: 69, height: 24)
                                .background(CustomColor.GrayScaleColor.gs6)
                                .cornerRadius(4, corners: .allCorners)
                            .padding(.bottom, 10)
                            
                            Text(voteStore.dailyVote.title)
                                .font(.createFont(weight: .bold, size: 16))
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                                .padding(.bottom, 18)
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 19, trailing: 20))
                    }
            }
        }
    }
}

