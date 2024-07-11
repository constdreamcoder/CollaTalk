//
//  Test.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/11/24.
//

import SwiftUI
import Combine
import Network

// 1. ToastView
struct ToastView2: View {
    var message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.black)
            .cornerRadius(8)
            .shadow(radius: 10)
    }
}

// 2. NetworkMonitor
class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    
    init() {
        self.monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

// 3. LoadingView
struct LoadingView2: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
                .padding()
            Text("Loading...")
                .foregroundColor(.white)
        }
        .padding(20)
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

// 4. WindowProvider
class WindowProvider2: ObservableObject {
    private var window: UIWindow?
    private var networkMonitor: NetworkMonitor
    
    init() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            self.window = UIWindow(windowScene: scene)
            self.window?.windowLevel = .alert + 1
        }
        self.networkMonitor = NetworkMonitor()
        self.networkMonitor.startMonitoring()
    }
    
    func showToast(message: String, duration: Double = 2.5) {
        guard let window = window else { return }
        
        let toastView = ToastView2(message: message)
        let hostingController = UIHostingController(rootView: toastView)
        hostingController.view.backgroundColor = .clear
        
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        // Calculate the size of the toast message
        let targetSize = hostingController.sizeThatFits(in: CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude))
        
        // Set the window's frame to match the toast message size and position it at the bottom of the screen
        window.frame = CGRect(x: (UIScreen.main.bounds.width - targetSize.width) / 2,
                              y: UIScreen.main.bounds.height - targetSize.height - 20,
                              width: targetSize.width,
                              height: targetSize.height)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.dismissView()
        }
    }
    
    func showNetworkStatus() {
        guard let window = window else { return }
        
        let hostingController = UIHostingController(rootView: NetworkStatusView().environmentObject(networkMonitor))
        hostingController.view.backgroundColor = .clear
        
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
    }
    
    func showLoading() {
        guard let window = window else { return }
        
        let hostingController = UIHostingController(rootView: LoadingView2())
        hostingController.view.backgroundColor = .brandBlack.withAlphaComponent(0.4)
        
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        window.frame = UIScreen.main.bounds
    }
    
    func dismissView() {
        window?.isHidden = true
        window = nil
    }
}

// 5. NetworkStatusView
struct NetworkStatusView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        VStack {
            if networkMonitor.isConnected {
                Text("Connected")
                    .foregroundColor(.green)
            } else {
                Text("Disconnected")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
        .shadow(radius: 10)
    }
}

// 6. ContentView
struct TestView: View {
    @StateObject private var windowProvider = WindowProvider2()
    
    var body: some View {
        VStack {
            Text("Hello, SwiftUI!")
                .padding()
            Button(action: {
                windowProvider.showToast(message: "This is a toast message!")
            }) {
                Text("Show Toast")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: {
                windowProvider.showNetworkStatus()
            }) {
                Text("Show Network Status")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: {
                windowProvider.showLoading()
            }) {
                Text("Show Loading")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
