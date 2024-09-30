//
//  BookmarkDeleteView.swift
//  Sachosaeng
//
//  Created by LJh on 9/24/24.
//

import SwiftUI

struct BookmarkDeleteView: View {
    @ObservedObject var bookmarkStore: BookmarkStore
    @EnvironmentObject var tabBarStore: TabBarStore
    @Binding var selectedButton: BookmarkType
    @Binding var isEdit: Bool
    @Binding var toast: Toast?
    
    var body: some View {
        Button {
            withAnimation {
                if selectedButton == .vote {
                    bookmarkStore.deleteAllVotesBookmark(bookmarkId: bookmarkStore.editBookmarkNumber) {
                        bookmarkStore.fetchCategoriesInbookmark()
                        toast = Toast(type: .success, message: "편집이 완료되었어요!")
                    }
                } else {
                    bookmarkStore.deleteAllInformationsInbookmark(informationId: bookmarkStore.editBookmarkNumber) {
                        bookmarkStore.fetchInformationCategoriesInbookmark()
                        toast = Toast(type: .success, message: "편집이 완료되었어요!")
                    }
                }
            }
            isEdit = false
            tabBarStore.switchTab = .bookMark
        } label: {
            Text("삭제")
                .font(.createFont(weight: .medium, size: 16))
                .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
                .foregroundStyle(CustomColor.GrayScaleColor.white)
                .background(CustomColor.GrayScaleColor.black)
                .cornerRadius(4)
        }
    }
}
