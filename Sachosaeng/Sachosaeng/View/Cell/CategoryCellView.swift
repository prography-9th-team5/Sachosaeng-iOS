//
//  CategoryCellView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct CategoryCellView: View {
    
    @Binding var isSelected: Bool
    let occupationNumber: Int
    let occupationImage: [Image] = [Image("mungmungE"), Image("mungmungE"), Image("mungmungE"), Image("mungmungE")]
    let occupationDescription: [String] = ["학생", "취업준비생", "1~3년차 직장인", "기타"]
    
    var body: some View {
//        Image("mungmungE")
//            .resizable()
//            .scaledToFit()
//            .clipShape(.circle)
//            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//            .frame(width: 104, height: 84)
        VStack {
            TempImageView(isBorder: true, width: 104, height: 84)
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
            Text("카테고리")
                .font(isSelected ? .createFont(weight: .extraBold, size: 16) : .createFont(weight: .medium, size: 16))
                .foregroundStyle(CustomColor.GrayScaleColor.black)
        }
    }
}
