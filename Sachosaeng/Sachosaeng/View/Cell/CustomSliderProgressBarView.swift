//
//  CustomSliderProgressBarView.swift
//  Sachosaeng
//
//  Created by LJh on 6/21/24.
//

import SwiftUI

struct CustomSliderProgressBarView: View {
    var progress: CGFloat
    var isHide: Bool
    var body: some View {
        HStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.3)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    Rectangle()
                        .foregroundColor(CustomColor.GrayScaleColor.gs6)
                        .frame(width: geometry.size.width * progress, height: geometry.size.height)
                }
                .cornerRadius(5)
            }
            .frame(height: 8)
            .overlay(alignment: .trailing) {
                if !isHide {
                    Image("Progressbaricon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
            }
        }
    }
}

#Preview {
    CustomSliderProgressBarView(progress: 1, isHide: false)
}
