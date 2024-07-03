//
//  UserFavoriteCategoryView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct UserFavoriteCategoryView: View {
    // MARK: - Properties
    @ObservedObject var categoryStore: CategoryStore = CategoryStore()
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var selectedCategories: [Bool] = []
    @State private var tapCount = 0
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0, content: {
                CustomSliderProgressBarView(progress: 1, isImageHide: true)
                    .padding(.trailing, 12)
                CustomSliderProgressBarView(progress: 1, isImageHide: false)
            })
            .padding(.bottom, 32)
            .padding(.top, 10)
            .padding(.horizontal, 20)

            HStack(spacing: 0) {
                CommonTitle(top: "선호하는 카테고리를",
                            topFont: .medium,
                            middle: "모두 선택해 주세요",
                            middleFont: .black,
                            footer: "*복수 선택이 가능해요",
                            footerFont: .light, isSuccessView: false)
                
                VStack(spacing: 0) {
                    Button {
                    // TODO: 유저정보 저장
                    } label: {
                        Text("SKIP")
                            .font(.createFont(weight: .light, size: 16))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                    }
                    .padding(.trailing, 20)
                    Spacer()
                }
            }
            .frame(height: 100)
                
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10, content: {
                    ForEach(categoryStore.categories, id: \.self) { category in
                        Button {
//                           print("\(categoryStore.categories.count) 버튼클릭")
                        } label: {
                            CategoryCellView(
                                tapCount: $tapCount, category: category, categoryNumber: category.categoryId)
                                .padding(20)
                        }
                    }
                }).onAppear() {
//                    print("\(categoryStore.categories.count) 온어피어")
                    gridSwitch()
                }
                .padding(20)
            } //: ScrollView
            Spacer()
            NavigationLink {
                SignSuccessView()
            } label: {
                Text("사초생 시작")
                    .font(.createFont(weight: .medium, size: 16))
            }
            .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
            .foregroundStyle(CustomColor.GrayScaleColor.white)
            .background(tapCount > 0
                        ? CustomColor.GrayScaleColor.black
                        : CustomColor.GrayScaleColor.gs4)
            .cornerRadius(4)
            .disabled(tapCount > 0)
            Spacer()
        } //:Vstack
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            Task {
                await categoryStore.fetchCategories()
                print(categoryStore.categoryCount)
                selectedCategories = Array(repeating: false, count: 11)
                //                print(categoryStore.categories)
            }
        })
    }
}

#Preview {
    NavigationStack {
        UserFavoriteCategoryView()
    }
}

extension UserFavoriteCategoryView {
    private var isSelected: Bool {
        return selectedCategories.contains(true)
    }
    
    private func gridSwitch() {
        gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
    }
}
