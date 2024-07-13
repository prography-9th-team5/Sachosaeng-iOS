//
//  CustomSliderProgressBarView.swift
//  Sachosaeng
//
//  Created by LJh on 6/21/24.
//

import SwiftUI

struct CustomSliderProgressBarView: View {
    var progress: CGFloat
    @State var setProgress: CGFloat = 0.0
    var isImageHide: Bool
    
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
                    
                    if !isImageHide {
                        Image("Progressbaricon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .offset(x: geometry.size.width * setProgress - 20)
                    } else {
                        Image("")
                            .frame(width: 28, height: 28)
                    }
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

#Preview {
    CustomSliderProgressBarView(progress: 1, isImageHide: false)
        .padding()
}
