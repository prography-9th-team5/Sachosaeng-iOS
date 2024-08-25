//
//  PopularVoteBodyView.swift
//  Sachosaeng
//
//  Created by LJh on 8/23/24.
//

import SwiftUI

struct PopularVoteCell: View {
    var vote: Vote
    @StateObject var voteStore: VoteStore
    var index: Int
    var body: some View {
        NavigationLink {
            VoteDetailView(voteId: vote.voteId, voteStore: voteStore)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 60)
                    .foregroundStyle(CustomColor.GrayScaleColor.white)
                
                HStack(spacing: 0) {
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
//            .frame(height: 60)
            .padding(.bottom, 6)
        }
    }
}
