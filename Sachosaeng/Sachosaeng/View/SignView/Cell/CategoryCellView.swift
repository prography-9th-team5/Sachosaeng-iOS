//
//  CategoryCellView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct CategoryCellView: View {
    
    @Binding var tapCount: Int
    @State var isSelected: Bool = false
    @State var category: Category
    @State var categoryNumber: Int
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(hex: isSelected ?  category.backgroundColor : "#F2F4F7" ))
                    .frame(width: 72, height: 72)
                    
                AsyncImage(url: URL(string: "\(category.iconUrl)"))
                .frame(width: 32, height: 32)
                .grayscale(isSelected ? 0 : 1)
                .opacity(isSelected ? 1 : 0.45)
            }
            Text("\(category.name)")
                .font(.createFont(weight: .medium, size: 16) )
                .foregroundStyle(CustomColor.GrayScaleColor.black)
        }
        .onTapGesture {
            isSelected.toggle()
            if isSelected {
                tapCount += 1
            } else {
                tapCount -= 1
            }
        }
    }
}
// TODO: 이미지 받으면 변경 예정

#Preview {
    CategoryCellView(tapCount: .constant(0), category: Category(categoryId: 4, name: "비지니스 매너", iconUrl: "https://sachosaeng.store/icon/resignation-and-job-change-32px-1x.png", backgroundColor: "#339FAF00", textColor: "#FF9FAF00"), categoryNumber: 2)
}

