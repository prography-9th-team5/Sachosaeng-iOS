//
//  TodayVoteView.swift
//  Sachosaeng
//
//  Created by LJh on 6/27/24.
//

import SwiftUI

struct TodayVoteView: View {
    @State var title: String = "친한사수 결혼식 축의금은 5만원이 적당해요"
    
    var body: some View {
        Button {
            
        } label: {
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(CustomColor.GrayScaleColor.black)
                    .frame(width: PhoneSpace.screenWidth - 40, height: 107)
                    .overlay(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("오늘의 투표")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs3)
                                .frame(width: 69, height: 24)
                                .background(CustomColor.GrayScaleColor.gs6)
                                .cornerRadius(4, corners: .allCorners)
                            .padding(.bottom, 12)
                            
                            Text(title)
                                .font(.createFont(weight: .bold, size: 16))
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                                .padding(.bottom, 5)
                            
                            Text("* 판단에 도움을 주기 위한 참고 자료로 활용해 주세요")
                                .font(.createFont(weight: .bold, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 19, trailing: 20))
                    }
            }
        }
    }
}

#Preview {
    TodayVoteView()
}
