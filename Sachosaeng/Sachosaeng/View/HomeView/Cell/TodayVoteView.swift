//
//  TodayVoteView.swift
//  Sachosaeng
//
//  Created by LJh on 6/27/24.
//

import SwiftUI

struct TodayVoteView: View {
    var dailyVote: Vote
    
    var body: some View {
        NavigationLink {
            VoteView(vote: dailyVote)
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
                            
                            Text(dailyVote.title)
                                .font(.createFont(weight: .bold, size: 16))
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                                .padding(.bottom, 18)
                            
//                            Text("* 판단에 도움을 주기 위한 참고 자료로 활용해 주세요")
//                                .font(.createFont(weight: .bold, size: 12))
//                                .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 19, trailing: 20))
                    }
            }
        }
    }
}

#Preview {
    TodayVoteView(dailyVote: dummyVote)
}
