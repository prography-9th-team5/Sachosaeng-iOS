//
//  TempImageView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct TempImageView: View {
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        Image("mungmungE")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .border(Color.black, width: 2)
            .overlay(
                Text("Width: \(Int(width)), Height: \(Int(height))")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
                    .padding([.bottom, .leading], 10),
                alignment: .bottomLeading
            )
    }
}

#Preview {
    TempImageView(width: 400, height: 400)
}
