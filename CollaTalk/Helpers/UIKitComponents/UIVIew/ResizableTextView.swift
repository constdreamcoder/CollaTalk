//
//  ResizableTextView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/24/24.
//

import SwiftUI

struct ResizableTextView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var height: CGFloat
    
    var maxHeight: CGFloat
    var textFont: UIFont
    
    var textColor: UIColor = .black
    var placeholder: String? = nil
    var placeholderColor: UIColor = .gray
    
    var textContainerInset: UIEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        if let placeholder = placeholder {
            textView.text = placeholder
            textView.textColor = placeholderColor
        } else {
            textView.textColor = textColor
        }
        
        textView.font = textFont
        textView.textContainerInset = textContainerInset
//        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.becomeFirstResponder()
        
        return textView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateHeight(uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: ResizableTextView
        
        init(parent: ResizableTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            
            if textView.text.isEmpty {
                textView.textColor = parent.placeholderColor
            } else {
                textView.textColor = parent.textColor
            }
            
            parent.updateHeight(textView)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = ""
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
            }
        }
    }
}

extension ResizableTextView {
    private func updateHeight(_ uiView: UITextView) {
        let size = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: .infinity))
        DispatchQueue.main.async {
            if size.height <= maxHeight {
                height = size.height
            }
        }
    }
}
