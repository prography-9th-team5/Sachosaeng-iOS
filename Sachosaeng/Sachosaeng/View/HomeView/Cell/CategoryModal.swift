//
//  CategoryModal.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct CategoryModal: View {
    @ObservedObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var tapCount = 0
    @State private var isMyCategory = true
    @State private var isEdit = false
    @State private var isAll = false
    @Binding var isSheet: Bool
    @Binding var categoryName: String
    
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
                                Button {
                                    if let index = UserStore.shared.currentUserCategories.firstIndex(of: category) {
                                        UserStore.shared.currentUserCategories.remove(at: index)
                                    } else {
                                        UserStore.shared.currentUserCategories.append(category)
                                    }
                                } label: {
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(UserStore.shared.currentUserCategories.contains(category) ? Color(hex: category.backgroundColor) : CustomColor.GrayScaleColor.gs2)
                                                .frame(width: 72, height: 72)
                                            
                                            AsyncImage(url: URL(string: "\(category.iconUrl)")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 32, height: 32)
                                                    .grayscale(UserStore.shared.currentUserCategories.contains(category) ? 0 : 1)
                                                    .opacity(UserStore.shared.currentUserCategories.contains(category) ? 1 : 0.25)
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
                        } else if isAll {
                            ForEach(categoryStore.allCatagory) { category in
                                Button {
                                    if category.name == "전체 보기" {
                                        categoryName = "전체"
                                    } else {
                                        categoryName = category.name
                                        voteStore.fetchHotVotesWithSelectedCategory(categoryId: voteStore.categoryID(category.name))
                                        voteStore.fetchLatestVotesInSelectedCategory(categoryId: voteStore.categoryID(category.name))
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
                                        voteStore.fetchHotVotesWithSelectedCategory(categoryId: voteStore.categoryID(category.name))
                                        voteStore.fetchLatestVotesInSelectedCategory(categoryId: voteStore.categoryID(category.name))
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
                            .background(CustomColor.GrayScaleColor.black)
                            .cornerRadius(4)
                    }
                }
                
            }
        } //: VSTACK
        .onAppear {
            
        }
    }
    
}

extension CategoryModal {
    private func gridSwitch() {
        gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
    }
    private func performCategorySetting(completion: @escaping () -> Void) {
        UserService.shared.updateUserCategory(UserStore.shared.currentUserCategories)
    }
    //    private func setSelectedCategories() {
    //        selectedCategories = UserStore.shared.currentUserCategories
    //    }
}
