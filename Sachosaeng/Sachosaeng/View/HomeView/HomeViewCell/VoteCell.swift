//
//  PopularVoteWithCategoryBodyView.swift
//  Sachosaeng
//
//  Created by LJh on 8/25/24.
//

import SwiftUI

struct VoteCell: View {
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    var vote: VoteWithoutCategory
    var index: Int
    
    var body: some View {
        NavigationLink {
            VoteDetailView(voteStore: voteStore, bookmarkStore: bookmarkStore, voteId: vote.voteId)
        } label: {
            
        }
    }
}
