//
//  BookmarkView.swift
//  Sachosaeng
//
//  Created by LJh on 8/12/24.
//

import SwiftUI

struct BookmarkView: View {
    @State private var toast: Toast? = nil
    @State private var selectedButton: String = "투표"
    @StateObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @StateObject var bookmarkStore: BookmarkStore
    @State private var selectedCategoryId: Int?
    @State var isEdit: Bool = false
    @Namespace private var animationNamespace
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                VStack {
                    HStack(spacing: 0) {
                        Text("북마크")
                            .font(.createFont(weight: .bold, size: 26))
                            .padding(.trailing, 7)
                            .frame(height: 40)

                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 0))
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                selectedButton = "투표"
                                isEdit = false
                            }
                        }) {
                            VStack {
                                Text("투표")
                                    .font(.createFont(weight: .bold, size: 18))
                                    .foregroundColor(selectedButton == "투표" ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs5)
                                if selectedButton == "투표" {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(CustomColor.GrayScaleColor.black)
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "underline", in: animationNamespace)
                                        .padding(.leading, 20)
                                } else {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(CustomColor.GrayScaleColor.gs3)
                                        .frame(height: 2)
                                        .padding(.leading, 20)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            withAnimation {
                                selectedButton = "연관콘텐츠"
                                isEdit = false
                            }
                        }) {
                            VStack {
                                Text("연관콘텐츠")
                                    .font(.createFont(weight: .bold, size: 18))
                                    .foregroundColor(selectedButton == "연관콘텐츠" ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs5)
                                    .padding(.trailing, 20)
                                if selectedButton == "연관콘텐츠" {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(CustomColor.GrayScaleColor.black)
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "underline", in: animationNamespace)
                                        .padding(.trailing, 20)
                                } else {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(CustomColor.GrayScaleColor.gs3)
                                        .frame(height: 2)
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } // Hstack <- 트표 연관컼ㄴ체
                
                HStack(spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(selectedButton == "투표" ? bookmarkStore.currentUserCategoriesBookmark : bookmarkStore.currentUserInformationCategoriesBookmark) { category in
                                    Button {
                                        withAnimation {
                                            selectedCategoryId = category.id
                                            if category.id == 0 {
                                                bookmarkStore.fetchAllVotesBookmark()
                                                bookmarkStore.fetchAllInformationInBookmark()
                                            } else {
                                                bookmarkStore.fetchVotesInBookmarkWithCategoryId(categoryId: category.id)
                                                bookmarkStore.fetchInformationInBookmarkWithCategory(categoryId: category.id)
                                            }
                                            proxy.scrollTo(category.name, anchor: .center)
                                        }
                                    } label: {
                                        HStack {
                                            if category.name != "전체 보기" {
                                                AsyncImage(url: URL(string: category.iconUrl)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 18, height: 18)
                                                } placeholder: {
                                                    Image(systemName: "bolt")
                                                        .resizable()
                                                        .frame(width: 18, height: 18)
                                                }
                                            }
                                            
                                            Text("\(category.name == "전체 보기" ? "ALL" : category.name)")
                                                .foregroundColor(Color(hex: category.textColor))
                                                .font(.createFont(weight: .semiBold, size: 15))
                                                .id(category.name)
                                        }
                                        .frame(height: 40)
                                        .padding(.horizontal, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color(hex: category.backgroundColor))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(selectedCategoryId == category.id ? CustomColor.GrayScaleColor.black : Color.clear, lineWidth: 1.4)
                                                )
                                        )
                                    }
                                    
                                }
                            }
                            .padding(EdgeInsets(top: 16, leading: 20, bottom: 24, trailing: 20))
                        }
                    }
                    
                    Button {
                        isEdit.toggle()
                    } label: {
                        Text("편집")
                            .font(.createFont(weight: .medium, size: 14))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                            .padding(8)
                            .background(CustomColor.GrayScaleColor.gs2)
                            .cornerRadius(4)
                    }
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 24, trailing: 20))
                }
                VStack(spacing: 0) {
                    if selectedButton == "투표" {
                        ScrollView(showsIndicators: false) {
                            if bookmarkStore.currentUserVotesBookmark.isEmpty {
                                VStack(spacing: 0) {
                                    Image("emptyIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .padding(.bottom, 16)
                                    
                                    Text("투표를 진행해\n북마크를 추가해주세요.")
                                        .font(.createFont(weight: .semiBold, size: 14))
                                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(18.2 - 14)
                                }
                                .padding(.top, 168)
                                .padding(.bottom, 311)
                            } else {
                                ForEach(bookmarkStore.currentUserVotesBookmark) { bookmark in
                                    VotesBookmarkCell(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore, isEdit: $isEdit, bookmark: bookmark)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            
                            if bookmarkStore.currentUserInformationBookmark.isEmpty {
                                VStack(spacing: 0) {
                                    Image("emptyIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .padding(.bottom, 16)
                                    
                                    Text("투표를 진행해\n북마크를 추가해주세요.")
                                        .font(.createFont(weight: .semiBold, size: 14))
                                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(18.2 - 14)
                                }
                                .padding(.top, 168)
                                .padding(.bottom, 311)
                            } else {
                                ForEach(bookmarkStore.currentUserInformationBookmark) { information in
                                    InformationBookmarkCell(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore, isEdit: $isEdit, information: information)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    if isEdit {
                        Button {
                            if selectedButton == "투표" {
                                bookmarkStore.deleteAllVotesBookmark(bookmarkId: bookmarkStore.editBookmarkNumber) {
                                    toast = Toast(type: .success, message: "편집이 완료되었어요!")
                                }
                            } else {
                                bookmarkStore.deleteAllInformationsInbookmark(informationId: bookmarkStore.editBookmarkNumber) {
                                    toast = Toast(type: .success, message: "편집이 완료되었어요!")
                                }
                            }
                            
                        } label: {
                            Text("버튼")
                        }
                    }
                }
                Spacer()
            }
        }
        .showToastView(toast: $toast)
    }
}
