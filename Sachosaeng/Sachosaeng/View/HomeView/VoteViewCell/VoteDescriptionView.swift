//
//  VoteDescriptionView.swift
//  Sachosaeng
//
//  Created by LJh on 8/25/24.
//

import SwiftUI

struct VoteDescriptionView: View {
    var body: some View {
        HStack {
            Text("사용자 데이터를 기반으로 제공되는 결과이며,\n판단에 도움을 주기 위한 참고 자료로 활용해 주세요.")
                .font(.createFont(weight: .medium, size: 12))
                .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                .lineLimit(2)
            Spacer()
        }
        .frame(height: 30)
        .padding(.top, 7)
    }
}

#Preview {
    VoteDescriptionView()
}
