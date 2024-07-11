//
//  VoteCellView.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct VoteListCellView: View {
    var titleName: String
    var isFavoriteVote: Bool
    let tempVoteList: [Vote] = tempVote
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(titleName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(CustomColor.GrayScaleColor.gs6)
                Spacer()
            }.padding(.horizontal, 20)
            
            ForEach(Array(tempVoteList.enumerated()), id: \.element.id) { index, vote in
                VoteCell(vote: vote, index: index + 1, isFavoriteVote: isFavoriteVote)
            }
        }
    }
}

struct VoteCell: View {
    var vote: Vote
    var index: Int
    var isFavoriteVote: Bool
    var body: some View {
        NavigationLink {
            VoteView()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 60)
                    .foregroundStyle(CustomColor.GrayScaleColor.white)
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("\(index)  \(vote.title)")
                                .font(.createFont(weight: .bold, size: 15))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(1)
                            Spacer()
                            if isFavoriteVote {
                                vote.image
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 12)
                                    .padding(.top,13)
                            }
                        }
                        
                        HStack(spacing: 0) {
                            Text("\(vote.voted)명 참여 중")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                        }
                        .padding(.leading, 14)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
        }
    }
}

#Preview {
    NavigationStack {
        VoteListCellView(titleName: "# 인기 투표", isFavoriteVote: false)
        
    }
}
