//
//  InformationBookmarkCell.swift
//  Sachosaeng
//
//  Created by LJh on 9/12/24.
//

import SwiftUI

struct InformationBookmarkCell: View {
    @StateObject var categoryStore: CategoryStore
    @StateObject var voteStore: VoteStore
    @StateObject var bookmarkStore: BookmarkStore
    var information: InformationInBookmark
    
    var body: some View {
        NavigationLink {
            InformationView(voteStore: voteStore, bookmarkStore: bookmarkStore, informationId: information.informationId)
        } label: {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 66)
                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                Text(information.title)
                                    .font(.createFont(weight: .bold, size: 14))
                                    .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .padding(.bottom, 10)
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
}
