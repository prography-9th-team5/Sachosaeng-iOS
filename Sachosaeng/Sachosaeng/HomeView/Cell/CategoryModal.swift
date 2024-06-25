//
//  CategoryModal.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct CategoryModal: View {
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var selectedCategories: [Bool] = Array(repeating: false, count: 10) // 난중에 갯수에 맞춰서 바꿀거
    private var isSelected: Bool {
        return selectedCategories.contains(true)
    }
    
    private func gridSwitch() {
        gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 32.24)
                .foregroundStyle(CustomColor.GrayScaleColor.gs4)
                .frame(width: 72, height: 6)
                .padding(.bottom, 28)
                .padding(.top, 20)
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        
                    } label: {
                        Text("내 카테고리")
                    }
                    .padding(.trailing, 24)
                    
                    Button {
                        
                    } label: {
                        Text("전체 카테고리")
                    }
                }
                Spacer()
            }
            .padding(.leading, 20)
            
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10, content: {
                    ForEach(0..<10) { num in
                        Button {
                        } label: {
                            
                        }
                    }
                })
            }
        }
        
    }
}

#Preview {
    CategoryModal()
}
