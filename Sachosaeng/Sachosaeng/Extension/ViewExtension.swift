//
//  ViewExtension.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI
import UIKit
extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color, _ font: UIFont.FontWeight, size: CGFloat) -> some View {
        let uiColor = UIColor(color)
        let font = UIFont.createFont(weight: font, size: size)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor, .font: font ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
    @available(iOS 14, *)
//    func navigationBarTitleTextFont(_ font: Font) -> some View {
//        
//    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
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
