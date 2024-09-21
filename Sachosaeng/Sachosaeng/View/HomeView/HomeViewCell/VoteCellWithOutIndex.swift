//
//  PopularVoteWithCategoryCell.swift
//  Sachosaeng
//
//  Created by LJh on 8/25/24.
//

import SwiftUI

struct VoteCellWithOutIndex: View {
    @StateObject var voteStore: VoteStore
    @StateObject var bookmarkStore: BookmarkStore
    var vote: VoteWithoutCategory
    
    var body: some View {
        NavigationLink {
            VoteDetailView(voteStore: voteStore, bookmarkStore: bookmarkStore, voteId: vote.voteId)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 60)
                    .foregroundStyle(vote.isVoted ? CustomColor.GrayScaleColor.gs3 : CustomColor.GrayScaleColor.white)
                
                HStack(spacing: 0) {
                    if vote.isVoted {
                        Image("checkCircle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 8)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text(vote.title)
                                .font(.createFont(weight: .bold, size: 15))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(1)
                            Spacer()
                        }
                        
                        if let participantCount = vote.participantCount, participantCount > 10 {
                            HStack(spacing: 0) {
                                Text("\(participantCount)명 참여 중")
                                    .font(.createFont(weight: .medium, size: 12))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
