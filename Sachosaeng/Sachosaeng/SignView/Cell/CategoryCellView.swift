//
//  CategoryCellView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct CategoryCellView: View {
    
    @Binding var isSelected: Bool
    var categoryNumber: Int
    var body: some View {
        VStack {
            TempImageView(isBorder: true, width: 104, height: 84)
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
            Text("카테고리")
                .font(isSelected 
                      ? .createFont(weight: .extraBold, size: 16)
                      : .createFont(weight: .medium, size: 16) )
                .foregroundStyle(CustomColor.GrayScaleColor.black)
        }
    }
}
// TODO: 이미지 받으면 변경 예정

#Preview {
    CategoryCellView(isSelected: .constant(true), categoryNumber: 2)
}
