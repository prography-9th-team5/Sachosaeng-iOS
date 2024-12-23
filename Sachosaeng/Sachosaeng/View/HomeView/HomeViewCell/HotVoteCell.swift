//
//  PopularVoteBodyView.swift
//  Sachosaeng
//
//  Created by LJh on 8/23/24.
//

import SwiftUI

struct HotVoteCell: View {
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    var vote: Vote
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
                        Image("checkCircle_true")
                            .circleImage(frame: 16)
                            .padding(.leading, 16)
                    } else {
                        Text("\(index)")
                            .font(.createFont(weight: .bold, size: 15))
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .padding(.leading, 16)
                    }
                    VStack(alignment: .leading, spacing: 0) {
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color(hex: vote.category.backgroundColor))
                        AsyncImage(url: URL(string: vote.category.iconUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        } placeholder: {
                            ProgressView()
                        }
                        
                    }
                    .padding(.trailing, 16)
                }
            }
            .padding(.bottom, 6)
        }
    }
}
