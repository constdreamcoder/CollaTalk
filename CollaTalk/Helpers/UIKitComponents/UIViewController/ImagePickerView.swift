//
//  ImagePickerView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage //선택된 이미지를 bindging 형식으로 저장
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary    //이미지 소스 선택
        imagePicker.allowsEditing = false    //이미지 편집기능 여부
        imagePicker.delegate = context.coordinator

        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(imagePickerView: self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var imagePickerView: ImagePickerView
        
        init(imagePickerView: ImagePickerView) {
            self.imagePickerView = imagePickerView
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imagePickerView.selectedImage = image
            }
            
            picker.dismiss(animated: true) //사진 라이브러리 해제
        }
    }
}
