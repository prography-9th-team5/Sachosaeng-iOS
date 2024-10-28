//
//  ToastView.swift
//  Sachosaeng
//
//  Created by LJh on 7/25/24.
//

import SwiftUI
enum ToastStyle {
    case saved
    case quit
    case success
    case savedBookMark
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .saved: return CustomColor.GrayScaleColor.gs4
        case .quit: return CustomColor.GrayScaleColor.gs4
        case .success: return CustomColor.GrayScaleColor.gs4
        case .savedBookMark: return CustomColor.GrayScaleColor.gs4
        }
    }
    
    var iconFileName: String {
        switch self {
            case .saved:
                return "checkIcon"
            case .quit:
                return "checkIcon"
            case .success:
                return "SuccessIcon"
            case .savedBookMark:
                return "SavedIcon"
        }
    }
}

struct Toast: Equatable {
    var type: ToastStyle
    var message: String
    var duration: Double = 2
}

struct ToastView: View {
    var type: Toast
    var onCancleTapped: (() -> Void)?
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .frame(height: 56)
            .padding(.horizontal, 20)
            .foregroundStyle(type.type.themeColor)
            .overlay(alignment: .leading) {
                HStack(spacing: 0) {
                    Image(type.type.iconFileName)
                        .padding(.leading, 40)
                    
                    Text(type.message)
                        .padding(.leading, 12)
                }
            }
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                mainToastView()
                    .padding(.bottom, 63)
            }
            .animation(.spring, value: toast)
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            ToastView(type: toast) {
                dismissToast()
            }
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
    
}
