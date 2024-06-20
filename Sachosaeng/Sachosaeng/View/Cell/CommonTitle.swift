//
//  CommonTitle.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct CommonTitle: View {
    var top: String
    var topFont: Font.FontWeight
    var middle: String
    var middleFont: Font.FontWeight
    var footer: String
    var footerFont: Font.FontWeight
    let lineHeight: CGFloat = 1.3 // 130%
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(top)
                    .font(.createFont(weight: topFont, size: 26))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 26 * (lineHeight - 1))

            HStack {
                Text(middle)
                    .font(.createFont(weight: middleFont, size: 26))
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text(footer)
                    .font(.createFont(weight: footerFont, size: 16))
                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 18)
        } //: Group
    }
}

#Preview {
    CommonTitle(top: "사초생과 함께",  topFont: .bold, middle: "사회생활 고민을 풀어봐요!",middleFont: .bold, footer: "사회초년생 집단지성 투표 플랫폼", footerFont: .medium)
}
