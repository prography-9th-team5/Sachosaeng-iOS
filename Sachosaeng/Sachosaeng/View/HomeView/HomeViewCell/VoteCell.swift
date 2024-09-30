//
//  PopularVoteWithCategoryBodyView.swift
//  Sachosaeng
//
//  Created by LJh on 8/25/24.
//

import SwiftUI

struct VoteCell: View {
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    var vote: VoteWithoutCategory
    var index: Int
    
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
                            .circleImage(frame: 16)
                            .padding(.leading, 16)
                    } else {
                        Text("\(index)")
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .padding(.leading, 16)
                    }
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(vote.title)
                                .font(.createFont(weight: .bold, size: 15))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(1)
                            Spacer()
                        }
                        
                        HStack(spacing : 0) {
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
                    .padding(.leading, 10)
                }
            }
        }
    }
}
