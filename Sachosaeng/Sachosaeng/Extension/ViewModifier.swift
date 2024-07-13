//
//  ViewModifier.swift
//  Sachosaeng
//
//  Created by LJh on 7/6/24.
//

import SwiftUI

public struct CustomBackButton: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    public typealias Action = () -> ()
    
    var action: Action?
    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        action?()
                        dismiss()
                    } label: {
                        Image("backButton")
                            .foregroundColor(.black)
                    }
                }
            }
    }
}

public struct DesignForNext: ViewModifier {
    @Binding var isSelected: Bool
    public func body(content: Content) -> some View {
        content
            .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
            .foregroundStyle(CustomColor.GrayScaleColor.white)
            .background(isSelected ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
            .cornerRadius(4)
    }
}

public struct DesignForNextWithTapCount: ViewModifier {
    @Binding var tapCount: Int
    public func body(content: Content) -> some View {
        content
            .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
            .foregroundStyle(CustomColor.GrayScaleColor.white)
            .background(tapCount > 0
                        ? CustomColor.GrayScaleColor.black
                        : CustomColor.GrayScaleColor.gs4)
            .cornerRadius(4)
            .disabled(tapCount == 0)
    }
}
