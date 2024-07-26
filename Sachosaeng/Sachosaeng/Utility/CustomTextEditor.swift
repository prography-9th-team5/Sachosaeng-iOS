//
//  CustomTextEditor.swift
//  Sachosaeng
//
//  Created by LJh on 7/26/24.
//

import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    private let maxLines = 6
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor(CustomColor.GrayScaleColor.gs2)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let lineHeight = textView.font?.lineHeight ?? 0
            let contentHeight = textView.contentSize.height
            let numberOfLines = Int(contentHeight / lineHeight)
            
            if numberOfLines > parent.maxLines {
                let endIndex = textView.text.index(textView.text.startIndex, offsetBy: textView.text.count - 1)
                textView.text = String(textView.text[..<endIndex])
                textView.scrollRangeToVisible(NSRange(location: textView.text.count - 1, length: 1))
            }
            
            parent.text = textView.text
        }
    }
}

#Preview {
    CustomTextEditor(text: .constant("CustomTextEditor"))
}
