//
//  PopularVoteWithCategoryCell.swift
//  Sachosaeng
//
//  Created by LJh on 8/25/24.
//

import SwiftUI

struct VoteCellWithOutIndex: View {
    @StateObject var voteStore: VoteStore
    var vote: VoteWithoutCategory
    
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
                        Text(vote.title)
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .lineLimit(1)
                        Spacer()
                    }
                    
                    HStack(spacing: 0) {
                        Text("\(vote.participantCount ?? 0)명 참여 중")
                            .font(.createFont(weight: .medium, size: 12))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
