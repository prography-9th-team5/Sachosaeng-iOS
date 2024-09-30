//
//  InformationBookmarkCell.swift
//  Sachosaeng
//
//  Created by LJh on 9/12/24.
//

import SwiftUI

struct InformationBookmarkCell: View {
    @ObservedObject var categoryStore: CategoryStore
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    @Binding var isEdit: Bool
    @State var isTap: Bool = false
    var information: InformationInBookmark
    
    var body: some View {
        ZStack {
            if isEdit {
                cellContent
                    .onTapGesture {
                        isTap.toggle()
                        bookmarkStore.updateEditBookmarkNumber(information.informationBookmarkId)
                    }
            } else {
                NavigationLink {
                    InformationView(voteStore: voteStore, bookmarkStore: bookmarkStore, informationId: information.informationId)
                } label: {
                    cellContent
                }
            }
        } //: ZSTACK
        .onAppear {
            bookmarkStore.editBookmarkNumber.removeAll()
        }
    }
    
    @ViewBuilder
    private var cellContent: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(height: 66)
            .foregroundStyle(CustomColor.GrayScaleColor.white)
            .overlay {
                HStack(spacing: 0) {
                    if isEdit {
                        Image("checkCircle_\(isTap)")
                            .circleImage(frame: 16)
                            .padding(.leading, 16)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        HStack(spacing: 0) {
                            Text(information.title)
                                .font(.createFont(weight: .bold, size: 14))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(1)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
    }
}
