//
//  VotesBookmarkCell.swift
//  Sachosaeng
//
//  Created by LJh on 9/11/24.
//

import SwiftUI

struct VotesBookmarkCell: View {
    @StateObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @StateObject var bookmarkStore: BookmarkStore
    @Binding var isEdit: Bool
    @State var isTap: Bool = false
    @State var bookmark: Bookmark
    
    var body: some View {
        ZStack {
            if isEdit {
                cellContent
                    .onTapGesture {
                        isTap.toggle()
                        if isTap {
                            bookmarkStore.updateEditBookmarkNumber(bookmark.voteBookmarkId)
                        }
                    }
            } else {
                NavigationLink {
                    VoteDetailView(voteStore: voteStore, bookmarkStore: bookmarkStore, voteId: bookmark.voteId)
                } label: {
                    cellContent
                } //: navigation
            }
        } //: ZSTACK
    }
    
    @ViewBuilder
    var cellContent: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(height: 66)
            .foregroundStyle(CustomColor.GrayScaleColor.white)
            .overlay {
                HStack(spacing: 0) {
                    if isEdit {
                        Image("checkCircle_\(isTap)")
                            .frame(width: 16, height: 16)
                            .padding(.leading, 16)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            
                            Text(bookmark.title)
                                .font(.createFont(weight: .bold, size: 14))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.bottom, 10)
                        HStack(spacing: 0) {
                            Text(bookmark.description)
                                .font(.createFont(weight: .bold, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
    }
}
