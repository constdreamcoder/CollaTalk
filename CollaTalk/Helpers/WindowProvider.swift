//
//  WindowProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/9/24.
//

import SwiftUI

final class WindowProvider: ObservableObject {
    private var window: UIWindow?
    
    func showToast(message: String, duration: Double = 2.5) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            window = UIWindow(windowScene: scene)
            window?.windowLevel = .statusBar
        }
        
        guard let window = window else { return }
        
        /// 토스트 메세지 window 생성
        let hostingController = UIHostingController(rootView: ToastView(message: message))
        hostingController.view.backgroundColor = .clear
        
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        /// 토스트 메세지 크기에 따른 window 크기 동적 변화
        let targetSize = hostingController.sizeThatFits(in: CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude))
        
        window.frame = CGRect(x: (UIScreen.main.bounds.width - targetSize.width) / 2,
                              y: UIScreen.main.bounds.height - targetSize.height - 80,
                              width: targetSize.width,
                              height: targetSize.height)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            guard let self else { return }
            dismissToast()
        }
    }
    
    private func dismissToast() {
        window?.isHidden = true
        window = nil
    }
}
