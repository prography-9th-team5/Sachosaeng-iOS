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

public struct PopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let popupType: PopupType
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    @EnvironmentObject var tabbarStore: TabBarStore
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(CustomColor.GrayScaleColor.black.opacity(0.7))
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.isPresented = false
                            tabbarStore.isOpacity = false
                        }
                    
                    PopupView(
                        isPresented: self.$isPresented,
                        popupType: self.popupType,
                        primaryAction: self.primaryAction,
                        secondaryAction: self.secondaryAction
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(
                isPresented
                ? .spring(response: 0.3)
                : .none,
                value: isPresented
            )
        }
    }
}
