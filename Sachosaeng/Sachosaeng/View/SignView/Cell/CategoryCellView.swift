//
//  CategoryCellView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct CategoryCellView: View {
    @Binding var tapCount: Int
    @State var category: Category
    @State var categoryNumber: Int
    @State private var isAllCategory: Bool = false
    @State private var isSelected: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(hex: category.backgroundColor))
                    .frame(width: 72, height: 72)
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
            if !isAllCategory {
                isSelected.toggle()
                if isSelected {
                    UserInfoStore.shared.selectedCategoriesInSignFlow.append(category)
                    tapCount += 1
                } else {
                    UserInfoStore.shared.selectedCategoriesInSignFlow.removeAll { $0 == category }
                    tapCount -= 1
                }
            }
        }
    }
}
