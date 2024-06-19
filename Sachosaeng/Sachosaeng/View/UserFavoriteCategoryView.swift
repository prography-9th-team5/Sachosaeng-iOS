//
//  UserFavoriteCategoryView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct UserFavoriteCategoryView: View {
    
    // MARK: - Properties
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var selectedCategories: [Bool] = Array(repeating: false, count: 10) // 난중에 갯수에 맞춰서 바꿀거
    private var isSelected: Bool {
        return selectedCategories.contains(true)
    }
    
    private func gridSwitch() {
        gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("2/2")
                        .font(.createFont(weight: .light, size: 16))
                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                    Spacer()
                    Button(action: {
                        // TODO: 유저정보 저장
                    }, label: {
                        Text("SKIP")
                            .font(.createFont(weight: .light, size: 16))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .padding(.top, 30)
                CommonTitle(top: "선호하는 카테고리를",
                            topFont: .medium,
                            middle: "모두 선택해 주세요",
                            middleFont: .black,
                            footer: "*복수 선택이 가능해요",
                            footerFont: .light)
            }
            
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10, content: {
                    ForEach(0..<10) { num in
                        Button(action: {
                            selectedCategories[num].toggle()
                            
                        }, label: {
                            CategoryCellView(isSelected: $selectedCategories[num], categoryNumber: num)
                                .padding(20)
                        })
                    }
                }).onAppear() {
                    gridSwitch()
                }
                .padding(20)
            } //: ScrollView
            Spacer()
            Button(action: {
                // TODO: 유저정보 저장
            }, label: {
                Text("사초생 시작")
                    .font(.createFont(weight: .medium, size: 16))
            })
            .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
            .foregroundStyle(CustomColor.GrayScaleColor.white)
            .background(isSelected ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
            .cornerRadius(4)
            Spacer()
        } //:Vstack
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    UserFavoriteCategoryView()
}
