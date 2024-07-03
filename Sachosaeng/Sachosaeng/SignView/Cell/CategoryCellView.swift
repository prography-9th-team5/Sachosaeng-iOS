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
            AsyncImage(url: URL(string: "\(category.iconUrl)"))
                .frame(width: 104, height: 84)
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
            Text("\(category.name)")
                .font(isSelected
                      ? .createFont(weight: .extraBold, size: 16)
                      : .createFont(weight: .medium, size: 16) )
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
//
//#Preview {
//    CategoryCellView(category: Category(categoryId: 1, name: "퇴사, 이직", iconUrl: "https://sachosaeng.store/icon/resignation-and-job-change-32px-1x.png", backgroundColor: "#339FAF00", textColor: "#FF9FAF00"), categoryNumber: 2)
//}
