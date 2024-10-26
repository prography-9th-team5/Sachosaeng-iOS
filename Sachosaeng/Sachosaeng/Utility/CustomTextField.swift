//
//  CustomTextField.swift
//  Sachosaeng
//
//  Created by LJh on 7/26/24.
//

import SwiftUI

public struct CustomTextField1: View {
    var maxLength: Int = 100
    var backgroundColor: Color = CustomColor.GrayScaleColor.gs2
    var foregroundStyle: Color = .black
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    var frame: CGFloat
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    public var body: some View {
        ZStack {
            TextField("", text: $text, prompt: Text(placeholder))
                .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
                .foregroundStyle(foregroundStyle)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .background(backgroundColor)
        }
        .frame(height: frame) // ZStack에도 frame 적용

    }
}
