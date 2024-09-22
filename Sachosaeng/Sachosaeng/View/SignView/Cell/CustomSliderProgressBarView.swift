//
//  CustomSliderProgressBarView.swift
//  Sachosaeng
//
//  Created by LJh on 6/21/24.
//

import SwiftUI

struct CustomSliderProgressBarView: View {
    var progress: CGFloat
    var isImageHide: Bool
    @State private var setProgress: CGFloat = 0.0

    var body: some View {
        HStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.3)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .cornerRadius(5)
                    
                    Rectangle()
                        .foregroundColor(CustomColor.GrayScaleColor.gs6)
                        .frame(width: geometry.size.width * setProgress, height: geometry.size.height)
                        .cornerRadius(5)
                    
                    Image("Progressbaricon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .offset(x: geometry.size.width * setProgress - 20)
                        .opacity(isImageHide ? 0 : 1)
                   
                }
            }
            .frame(height: 8)
            .onAppear {
                if isImageHide {
                    setProgress = progress
                } else {
                    withAnimation(.linear(duration: 1.2)) {
                        setProgress = progress
                    }
                }
            }
        }
    }
}
