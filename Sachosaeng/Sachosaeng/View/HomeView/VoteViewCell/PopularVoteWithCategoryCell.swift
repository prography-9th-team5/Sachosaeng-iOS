//
//  PopularVoteWithCategoryBodyView.swift
//  Sachosaeng
//
//  Created by LJh on 8/25/24.
//

import SwiftUI

struct PopularVoteWithCategoryCell: View {
    @StateObject var voteStore: VoteStore
    var vote: VoteOptionForHotVoteWithCategory
    var index: Int
    var body: some View {
        NavigationLink {
            VoteDetailView(voteId: vote.voteId, voteStore: voteStore)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 60)
                    .foregroundStyle(CustomColor.GrayScaleColor.white)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("\(index)")
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .padding(.trailing, 8)
                        Text(vote.title)
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .lineLimit(1)
                        Spacer()
                    }
                    
                    HStack(spacing : 0) {
                        Text("\(index)")
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(Color.clear)
                            .padding(.trailing, 8)
                        Text("\(vote.participantCount ?? 0)명 참여 중")
                            .font(.createFont(weight: .medium, size: 12))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
