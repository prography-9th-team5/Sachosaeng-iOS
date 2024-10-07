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
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor, .font: font! ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
    @available(iOS 14, *)
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
    func disablePressed(isDisabled: Binding<Bool>) -> some View {
        self
            .disabled(isDisabled.wrappedValue)
            .onTapGesture {
                isDisabled.wrappedValue = true
            }
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

extension UINavigationController: @retroactive UIBarPositioningDelegate {}
extension UINavigationController: @retroactive UINavigationBarDelegate, @retroactive UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        var isEnabled: Bool = false
        switch ViewTracker.shared.currentView {
            case .home, .sign, .bookmark, .success:
                isEnabled = false
            case .mypage, .voteDetail, .category, .information, .quit:
                isEnabled = true
        }
        return viewControllers.count > 1 && isEnabled
        
    }
}
