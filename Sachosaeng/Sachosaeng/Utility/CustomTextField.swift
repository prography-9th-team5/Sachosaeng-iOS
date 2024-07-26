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
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    public init(maxLength: Int = 100, backgroundColor: Color = .blue, foregroundStyle: Color = .black, placeholder: String, keyboardType: UIKeyboardType = .default, text: Binding<String>, isFocused: Bool = false) {
        self.maxLength = maxLength
        self.backgroundColor = backgroundColor
        self.foregroundStyle = foregroundStyle
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self._text = text
        self.isFocused = isFocused
    }
    
    public var body: some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 6)
//                .stroke(Color.gray08, lineWidth: 1)
//                .background(RoundedRectangle(cornerRadius: 6)
//                .foregroundStyle(backgroundColor))
            TextField("", text: $text, prompt: Text(placeholder))
                .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
                
                .foregroundStyle(foregroundStyle)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                
//            autocorrectionType = .no
//            spellCheckingType = .no
            
//            if isFocused {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        text = ""
//                    }, label: {
//                        Image(systemName: "xmark.circle")
//                            .font(.system(size: 20))
//                            .foregroundStyle(Color.gray06)
//                    })
//                    .padding(.trailing, 14)
//                }
//            }
        }
        .frame(height: 45)
//        .onChange(of: text) { oldValue, newValue in
//            if newValue.count > maxLength {
//                text = String(newValue.prefix(maxLength))
//                isFocused = false
//            }
//            _ = oldValue
//        }
    }
}
