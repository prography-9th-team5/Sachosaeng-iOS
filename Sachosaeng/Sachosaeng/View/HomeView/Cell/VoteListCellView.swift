//
//  VoteCellView.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct VoteListCellView: View {
    var votes: [Vote]
    var categoty: Category?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image("FavoriteVoteIcon")
                    .padding(.trailing, 6)
                Text("인기투표")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(CustomColor.GrayScaleColor.gs6)
                Spacer()
            }
            .padding(.bottom, 12)
            ForEach(votes, id: \.self) { vote in
                VoteCell(vote: vote, index: 1)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct VoteCell: View {
    var vote: Vote
    var index: Int
    @State var iss: Bool = false
    var body: some View {
        Button {
            iss.toggle()
        } label: {
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 60)
                    .foregroundStyle(CustomColor.GrayScaleColor.gs4)
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("\(index)  \(vote.title)")
                                .font(.createFont(weight: .bold, size: 15))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(1)
                            Spacer()
//                                vote.image
//                                    .frame(width: 18, height: 18)
//                                    .padding(.leading, 12)
//                                    .padding(.top,13)
                        }
                        
                        HStack(spacing: 0) {
                            Text("\(vote.participantCount)명 참여 중")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                        }
                        .padding(.leading, 14)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(height: 60)
            .padding(.bottom, 6)
        }
        .buttonStyle(.plain)
        .navigationDestination(isPresented: $iss) {
            VoteView(vote: vote)
        }
    }
}

#Preview {
    NavigationStack {
        VoteListCellView(votes: [dummyVote])
    }
}
