//
//  ViewExtension.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    public func customBackbutton(action: (() -> ())? = nil) -> some View {
        modifier(CustomBackButton(action: action))
    }
    
    func showToastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
    
    func showPopupView(
        isPresented: Binding<Bool>,
        message: PopupType,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void
    ) -> some View {
        return modifier(
            PopupModifier(
                isPresented: isPresented,
                popupType: message,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction
            )
        )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
