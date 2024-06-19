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
    
    var body: some View {
        Group {
            HStack {
                Text(top)
                    .font(.createFont(weight: topFont, size: 26))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            HStack {
                Text(middle)
                    .font(.createFont(weight: middleFont, size: 26))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            HStack {
                Text(footer)
                    .font(.createFont(weight: footerFont, size: 16))
                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        } //: Group
    }
}

#Preview {
    CommonTitle(top: "top",  topFont: .bold, middle: "middle",middleFont: .black, footer: "footer", footerFont: .black)
}
