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
//                    .fill(Color(hex: isSelected ? category.backgroundColor : "#F2F4F7"))
                    .fill(Color(hex: category.backgroundColor))
                    .frame(width: 72, height: 72)
//                    .border(CustomColor.GrayScaleColor.black, width: 1.4)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? CustomColor.GrayScaleColor.black : Color.clear, lineWidth: 1.4)
                    )
                    
                AsyncImage(url: URL(string: "\(category.iconUrl)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    case .failure(let error):
                        Text("Failed to load image: \(error.localizedDescription)")
                    @unknown default:
                        Text("Unknown state")
                    }
                }
            }
            Text("\(category.name)")
                .font(.createFont(weight: isSelected ? .bold : .medium, size: 16) )
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
    CategoryCellView(tapCount: .constant(0), category: Category(categoryId: 4, name: "비지니스 매너", iconUrl: "https://sachosaeng.store/icon/all-2x.png", backgroundColor: "#E4E7EC", textColor: "#FF9FAF00"), categoryNumber: 2)
}

