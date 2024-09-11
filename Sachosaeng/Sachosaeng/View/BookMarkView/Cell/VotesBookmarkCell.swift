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
    var bookmark: Bookmark
    
    var body: some View {
        NavigationLink {
            VoteDetailView(voteId: bookmark.voteId, voteStore: voteStore, bookmarkStore: bookmarkStore)
        } label: {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 66)
                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                    HStack(spacing: 0) {
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
    }
}

