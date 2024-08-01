//
//  WindowProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/9/24.
//

import SwiftUI

final class WindowProvider: ObservableObject {
    
    private var window: UIWindow?
    private var loadingViewWindow: UIWindow?
    private var alertWindow: UIWindow?
    
    // MARK: - 토스트 메세지
    /// 토스트 메세지 표시 함수
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
    
    /// 토스트 메세지 닫는 함수
    private func dismissToast() {
        window?.isHidden = true
        window = nil
    }
    
    // MARK: - Loading View
    /// Loading View 표시 함수
    func showLoading() {
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            loadingViewWindow = UIWindow(windowScene: scene)
            loadingViewWindow?.windowLevel = .statusBar
        }
        
        guard let loadingViewWindow = loadingViewWindow else { return }
        
        let hostingController = UIHostingController(rootView: LoadingView())
        hostingController.view.backgroundColor = .brandBlack.withAlphaComponent(0.4)
        
        loadingViewWindow.rootViewController = hostingController
        loadingViewWindow.makeKeyAndVisible()
        
        loadingViewWindow.frame = UIScreen.main.bounds
    }
    
    /// Loading View 닫는 함수
    func dismissLoading() {
        loadingViewWindow?.isHidden = true
        loadingViewWindow = nil
    }
    
    // MARK: - Alert View
    /// Alert View 표시 함수
    func showAlert(alertType: AlertType, confirmAction: @escaping () -> Void) {
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            alertWindow = UIWindow(windowScene: scene)
            alertWindow?.windowLevel = .statusBar
        }
        
        guard let alertWindow = alertWindow else { return }
        
        /// Alert Type에 따른 cancel action 정의
        var cancelAction: (() -> Void)?
        if alertType == .leaveWorkspaceAsAnOwner
            || alertType == .leaveChannelAsAnOwner
            || alertType == .unableToChangeWorkspaceOwner
            || alertType == .unableToChangeChannelOwner {
            cancelAction = nil
        } else {
            cancelAction = { [weak self] in
                guard let self else { return }
                dismissAlert()
            }
        }
                
        let hostingController = UIHostingController(
            rootView: AlertView(
                alertType: alertType,
                confirmAction: confirmAction,
                cancelAction: cancelAction
            )
        )
        hostingController.view.backgroundColor = .clear
        
        alertWindow.rootViewController = hostingController
        alertWindow.makeKeyAndVisible()
        
        alertWindow.frame = UIScreen.main.bounds
    }
    
    /// Alert View 닫는 함수
    func dismissAlert() {
        alertWindow?.isHidden = true
        alertWindow = nil
    }
}
