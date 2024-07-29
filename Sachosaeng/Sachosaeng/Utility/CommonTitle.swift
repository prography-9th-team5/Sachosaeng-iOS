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
    var isSuccessView: Bool
    private let lineHeight: CGFloat = 1.338 //
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if isSuccessView { Spacer() }
                Text(top)
                    .font(.createFont(weight: topFont, size: 26))
                
                Spacer()
            }
            .padding(.bottom, 26 * (lineHeight - 1))

            HStack {
                if isSuccessView { Spacer() }
                Text(middle)
                    .font(.createFont(weight: middleFont, size: 26))
                Spacer()
            }

            HStack {
                if isSuccessView { Spacer() }
                Text(footer)
                    .font(.createFont(weight: footerFont, size: 16))
                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                Spacer()
            }
            .padding(.top, 14.5)
            
        } //: Group
        .padding(.horizontal, 20)
    }
}

#Preview {
    CommonTitle(top: "사초생과 함께",  topFont: .bold, middle: "사회생활 고민을 풀어봐요!",middleFont: .bold, footer: "사회초년생 집단지성 투표 플랫폼", footerFont: .medium, isSuccessView: false)
}
