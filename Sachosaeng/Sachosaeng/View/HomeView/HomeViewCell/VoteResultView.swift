//
//  VoteResultView.swift
//  Sachosaeng
//
//  Created by LJh on 8/25/24.
//

import SwiftUI

struct VoteResultView: View {
    @EnvironmentObject var userInfoStore: UserInfoStore
    var description: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image("vote_\(userInfoStore.currentUserState.userType)")
            VStack(spacing: 0) {
                Text(description)
                    .font(.createFont(weight: .medium, size: 14))
            }
            .padding(.leading, 4.5)
            Spacer()
        }
        .padding()
    }
}
