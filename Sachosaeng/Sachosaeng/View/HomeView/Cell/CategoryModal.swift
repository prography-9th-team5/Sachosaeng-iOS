//
//  CategoryModal.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct CategoryModal: View {
    @ObservedObject var categoryStore: CategoryStore
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var tapCount = 0
    @State private var isMyCategory = true
    @State private var isEdit = false
    @State private var isAll = false
    @State private var selectedCategories: [Category] = []
    @Binding var isSheet: Bool
    @Binding var categoryName: String
    
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
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Button {
                            withAnimation {
                                isMyCategory = true
                                isEdit = false
                                isAll = false
                            }
                        } label: {
                            Text("내 카테고리")
                                .font(.createFont(weight: isMyCategory ? .bold : .medium, size: 18))
                                .foregroundStyle(isMyCategory ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs5)
                        }
                        .padding(.trailing, 24)
                        
                        Button {
                            withAnimation {
                                isMyCategory = false
                                isEdit = false
                                isAll = true
                            }
                        } label: {
                            Text("전체 카테고리")
                                .font(.createFont(weight: isMyCategory ? .medium : .bold, size: 18))
                                .foregroundStyle(isMyCategory ? CustomColor.GrayScaleColor.gs5 : CustomColor.GrayScaleColor.black)
                        }
                        
                        Spacer()
                        
                        if isMyCategory {
                            Button {
                                isEdit.toggle()
                            } label: {
                                Text("편집")
                                    .font(.createFont(weight: .medium, size: 14))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 1)
                
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 32.24)
                        .foregroundStyle(.clear)
                        .frame(width: isMyCategory ? 0 : 104.5, height: 2)
                    RoundedRectangle(cornerRadius: 32.24)
                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                        .frame(width: isMyCategory ? 86 : 106, height: 2)
                    Spacer()
                }
                .padding(.top, 14)
            }
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 20))
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    Spacer()
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        if isEdit {
                            ForEach(categoryStore.categories) { category in
                                let isSelected = selectedCategories.contains { $0.id == category.id }
                                Button {
                                    if let index = selectedCategories.firstIndex(where: { $0.id == category.id }) {
                                        selectedCategories.remove(at: index)
                                    } else {
                                        selectedCategories.append(category)
                                    }
                                }  label: {
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: category.backgroundColor))
                                                .frame(width: 72, height: 72)
                                                .overlay(
                                                    Circle()
                                                        .stroke(isSelected ? CustomColor.GrayScaleColor.black : Color.clear, lineWidth: 1.4)
                                                )
                                            AsyncImage(url: URL(string: "\(category.iconUrl)")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                            } placeholder: {
                                                ProgressView()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                            }
                                        }
                                        Text("\(category.name)")
                                            .font(.createFont(weight: isSelected ? .bold : .medium, size: 16) )
                                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    }
                                    .padding(.bottom, 32)
                                }
                            }
                        } else if isAll {
                            ForEach(categoryStore.allCatagory) { category in
                                Button {
                                    if category.name == "전체 보기" {
                                        categoryName = "전체"
                                    } else {
                                        categoryName = category.name
                                    }
                                    isSheet = false
                                } label: {
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: category.backgroundColor))
                                                .frame(width: 72, height: 72)
                                            AsyncImage(url: URL(string: "\(category.iconUrl)")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                            } placeholder: {
                                                ProgressView()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                            }
                                        }
                                        Text("\(category.name)")
                                            .font(.createFont(weight: .medium, size: 16))
                                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    }
                                    .padding(.bottom, 32)
                                }
                            }
                        } else {
                            ForEach(UserStore.shared.currentUserCategories) { category in
                                Button {
                                    if category.name == "전체 보기" {
                                        categoryName = "전체"
                                    } else {
                                        categoryName = category.name
                                    }
                                    isSheet = false
                                } label: {
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: category.backgroundColor))
                                                .frame(width: 72, height: 72)
                                            AsyncImage(url: URL(string: "\(category.iconUrl)")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                            } placeholder: {
                                                ProgressView()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                            }
                                        }
                                        Text("\(category.name)")
                                            .font(.createFont(weight: .medium, size: 16))
                                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    }
                                    .padding(.bottom, 32)
                                }
                            }
                        }
                    }
                    .onAppear {
                        gridSwitch()
                    }
                } // : Scrollview
                .padding(.top, 28)
                .background(CustomColor.GrayScaleColor.gs1)
                .overlay {
                    if UserStore.shared.currentUserCategories.isEmpty && !isEdit && !isAll {
                        VStack(spacing: 0) {
                            Image("emptyIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .padding(.bottom, 16)
                            
                            Text("관심 카테고리가 없어요!\n편집을 눌러 카테고리를 추가해 보세요")
                                .font(.createFont(weight: .semiBold, size: 14))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .lineSpacing(18.2 - 14)
                        }
                        .padding(.top, 168)
                        .padding(.bottom, 311)
                    }
                }
                if isEdit {
                    Button {
                        isSheet = false
                        performCategorySetting {
                            UserService.shared.getUserCategories()
                        }
                    } label: {
                        Text("완료")
                            .font(.createFont(weight: .medium, size: 16))
                            .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .background(!selectedCategories.isEmpty
                                        ? CustomColor.GrayScaleColor.black
                                        : CustomColor.GrayScaleColor.gs4)
                            .cornerRadius(4)
                            .disabled(selectedCategories.isEmpty)
                    }
                }
                
            }
        } //: VSTACK
    }
    
    private func performCategorySetting(completion: @escaping () -> Void) {
        UserStore.shared.currentUserCategories = selectedCategories
        UserService.shared.updateUserCategory(selectedCategories)
    }
}

#Preview {
    CategoryModal(categoryStore: CategoryStore(), isSheet: .constant(true), categoryName: .constant("전체"))
}
