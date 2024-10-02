//
//  BookmarkView.swift
//  Sachosaeng
//
//  Created by LJh on 8/12/24.
//

import SwiftUI

enum BookmarkType {
    case vote
    case content
}

struct BookmarkView: View {
    @ObservedObject var categoryStore: CategoryStore
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    @EnvironmentObject var userInfoStore: UserInfoStore
    @EnvironmentObject var tabBarStore: TabBarStore
    @Binding var path: NavigationPath
    @State private var toast: Toast? = nil
    //    @State private var selectedButton: BookmarkType = .vote
    @State private var selectedCategoryId: Int?
    //    @State var isEdit: Bool = false
    
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
                        Button {
                            path.append(PathType.myPage)
                        } label: {
                            Image("온보딩_\(userInfoStore.currentUserState.userType)")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
                    
                    HStack(spacing: 0) {
                        Button {
                            withAnimation {
                                voteStore.categoryNameForBookmark = "ALL"
                                bookmarkStore.selectedButton = .vote
                                bookmarkStore.isEditBookMark = false
                                tabBarStore.switchTab = .bookMark
                            }
                        } label: {
                            VStack {
                                Text("투표")
                                    .font(.createFont(weight: .bold, size: 18))
                                    .foregroundColor(bookmarkStore.selectedButton == .vote ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs5)
                                if bookmarkStore.selectedButton == .vote {
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
                        
                        Button {
                            withAnimation {
                                voteStore.categoryNameForBookmark = "ALL"
                                bookmarkStore.selectedButton = .content
                                bookmarkStore.isEditBookMark = false
                                tabBarStore.switchTab = .bookMark
                            }
                        } label: {
                            VStack {
                                Text("연관콘텐츠")
                                    .font(.createFont(weight: .bold, size: 18))
                                    .foregroundColor(bookmarkStore.selectedButton == .content ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs5)
                                    .padding(.trailing, 20)
                                if bookmarkStore.selectedButton == .content {
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
                } // Hstack
                
                // 카테고리 셀들 나열하는곳
                HStack(spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(bookmarkStore.selectedButton == .vote ? bookmarkStore.currentUserCategoriesBookmark : bookmarkStore.currentUserInformationCategoriesBookmark) { category in
                                    Button {
                                        withAnimation {
                                            voteStore.categoryNameForBookmark = category.name
                                            selectedCategoryId = category.id
                                            switch bookmarkStore.selectedButton {
                                            case .vote:
                                                if category.id == 0 {
                                                    bookmarkStore.fetchAllVotesBookmark()
                                                } else {
                                                    bookmarkStore.fetchVotesInBookmarkWithCategoryId(categoryId: category.id)
                                                }
                                            case .content:
                                                if category.id == 0 {
                                                    bookmarkStore.fetchAllInformationInBookmark()
                                                } else {
                                                    bookmarkStore.fetchInformationInBookmarkWithCategory(categoryId: category.id)
                                                }
                                            }
                                            
                                            proxy.scrollTo(category.name, anchor: .center)
                                        }
                                    } label: {
                                        HStack {
                                            if category.name != "ALL" {
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
                                            
                                            Text(category.name)
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
                                                        .stroke(voteStore.categoryNameForBookmark == category.name ? CustomColor.GrayScaleColor.black : Color.clear, lineWidth: 1.4)
                                                )
                                        )
                                    }
                                }
                            }
                            .padding(EdgeInsets(top: 16, leading: 20, bottom: 24, trailing: 20))
                        }
                    }
                    
                    if isShowEdit(selectedButton: bookmarkStore.selectedButton) {
                        Button {
                            bookmarkStore.isEditBookMark = true
                            tabBarStore.switchTab = .edit
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
                }
                // 밑에 북마크된 셀들 나타나는곳
                VStack(spacing: 0) {
                    switch bookmarkStore.selectedButton {
                        case .vote:
                            ScrollView(showsIndicators: false) {
                                if bookmarkStore.currentUserVotesBookmark.isEmpty {
                                    VStack(spacing: 0) {
                                        Image("emptyIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .padding(.bottom, 16)
                                        
                                        Text("북마크한 투표가 없어요")
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
                                        VotesBookmarkCell(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore, isEdit: $bookmarkStore.isEditBookMark, bookmark: bookmark)
                                            .padding(.horizontal, 20)
                                    }
                                    .onAppear {
                                        let categoryID = voteStore.categoryID(voteStore.categoryNameForBookmark)
                                        Task {
                                            if voteStore.categoryNameForBookmark == "ALL" {
                                                bookmarkStore.fetchAllVotesBookmark()
                                            } else {
                                                bookmarkStore.fetchVotesInBookmarkWithCategoryId(categoryId: categoryID)
                                            }
                                        }
                                    }
                                }
                                Spacer()
                            }
                        case .content:
                            ScrollView(showsIndicators: false) {
                                if bookmarkStore.currentUserInformationBookmark.isEmpty {
                                    VStack(spacing: 0) {
                                        Image("emptyIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .padding(.bottom, 16)
                                        
                                        Text("북마크한 연관컨텐츠가 없어요")
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
                                        InformationBookmarkCell(categoryStore: categoryStore, voteStore: voteStore, bookmarkStore: bookmarkStore, isEdit: $bookmarkStore.isEditBookMark, information: information)
                                            .padding(.horizontal, 20)
                                    }
                                    .onAppear {
                                        let categoryID = voteStore.categoryID(voteStore.categoryNameForBookmark)
                                        if voteStore.categoryNameForBookmark == "ALL" {
                                            bookmarkStore.fetchAllInformationInBookmark()
                                        } else {
                                            bookmarkStore.fetchInformationInBookmarkWithCategory(categoryId: categoryID)
                                        }
                                    }
                                }
                                Spacer()
                            }
                    }
                }
            }
        }
        .showToastView(toast: $toast)
        .onAppear {
            ViewTracker.shared.updateCurrentView(to: .bookmark)
            ViewTracker.shared.currentTap = .bookmark
            AnalyticsService.shared.trackView("Bookmark")
        }
    }
}

extension BookmarkView {
    private func isShowEdit(selectedButton: BookmarkType) -> Bool {
        switch selectedButton {
            case .vote:
                return !bookmarkStore.currentUserVotesBookmark.isEmpty
            case .content:
                return !bookmarkStore.currentUserInformationBookmark.isEmpty
        }
    }
}

