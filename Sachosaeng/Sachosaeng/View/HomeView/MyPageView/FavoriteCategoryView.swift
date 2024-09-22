//
//  FavoriteView.swift
//  Sachosaeng
//
//  Created by LJh on 9/21/24.
//

import SwiftUI

enum FavoriteCategory {
    case all
    case edit
    case empty
}

struct FavoriteCategoryView: View {
    @ObservedObject var categoryStore: CategoryStore
    @EnvironmentObject var userStore: UserInfoStore
    @Binding var path: NavigationPath
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var isFavoriteCategory: FavoriteCategory = .all
    @State private var toast: Toast? = nil
    
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("내 카테고리")
                            .padding(.bottom, 14)
                            .font(.createFont(weight: .semiBold, size: 18))
                        RoundedRectangle(cornerRadius: 32.24)
                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                            .frame(width: 80, height: 2)
                    }
                    Spacer()
                    
                    if isFavoriteCategory == .edit {
                        
                    } else {
                        Button {
                            isFavoriteCategory = .edit
                        } label: {
                            Text("편집")
                                .font(.createFont(weight: .medium, size: 14))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                                .padding(.bottom, 5)
                        }
                    }
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    switch isFavoriteCategory {
                    case .all:
                        LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                            ForEach(UserInfoStore.shared.currentUserCategories) { category in
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
                    case .edit:
                        LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                            ForEach(categoryStore.categories) { category in
                                Button {
                                    if let index = userStore.currentUserCategories.firstIndex(of: category) {
                                        userStore.currentUserCategories.remove(at: index)
                                    } else {
                                        userStore.currentUserCategories.append(category)
                                    }
                                } label: {
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(userStore.currentUserCategories.contains(category) ? Color(hex: category.backgroundColor) : CustomColor.GrayScaleColor.gs2)
                                                .frame(width: 72, height: 72)
                                            
                                            AsyncImage(url: URL(string: "\(category.iconUrl)")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                                    .grayscale(userStore.currentUserCategories.contains(category) ? 0 : 1)
                                                    .opacity(userStore.currentUserCategories.contains(category) ? 1 : 0.25)
                                            } placeholder: {
                                                ProgressView()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                            }
                                        }
                                        Text("\(category.name)")
                                            .font(.createFont(weight: .medium, size: 16))
                                            .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                    }
                                    .padding(.bottom, 32)
                                }
                            
                        }
                    }
                    case .empty:
                        Spacer()
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
                        Spacer()
                    }
                }
                .padding(.top, 28)
                .frame(width: PhoneSpace.screenWidth)
                .background(CustomColor.GrayScaleColor.white)
                .showToastView(toast: $toast)
            }
            .navigationTitle("관심사 설정")
            .navigationBarTitleTextColor(CustomColor.GrayScaleColor.gs6, .medium, size: 18)
            .navigationBarTitleDisplayMode(.inline)
            .customBackbutton()
            .onAppear {
                gridSwitch()
                if userStore.currentUserCategories.isEmpty { isFavoriteCategory = .empty }
            }
            .overlay(alignment: .bottom) {
                if isFavoriteCategory == .edit {
                    Button {
                        toast = Toast(type: .quit, message: "저장되었습니다")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            path.removeLast()
                        }
                        performCategorySetting {
                            UserService.shared.getUserCategories()
                        }
                    } label: {
                        Text("완료")
                            .font(.createFont(weight: .medium, size: 16))
                            .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .background(CustomColor.GrayScaleColor.black)
                            .cornerRadius(4)
                    }
                }
            }
        }
    }
}

extension FavoriteCategoryView {
    private func gridSwitch() {
        gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
    }
    private func performCategorySetting(completion: @escaping () -> Void) {
        UserService.shared.updateUserCategory(UserInfoStore.shared.currentUserCategories)
    }
}
