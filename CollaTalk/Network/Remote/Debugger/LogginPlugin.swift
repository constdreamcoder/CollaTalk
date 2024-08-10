//
//  LogginPlugin.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import Foundation
import Moya

final class LoggerPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: any TargetType) -> URLRequest {
        var request = request
        let accessToken = UserDefaultsManager.getObject(forKey: .userInfo, as: UserInfo.self)?.token.accessToken ?? ""
        let refreshToken = UserDefaultsManager.getObject(forKey: .userInfo, as: UserInfo.self)?.token.refreshToken ?? ""
        request.setValue(accessToken, forHTTPHeaderField: Headers.authorization.rawValue)
        request.setValue(refreshToken, forHTTPHeaderField: Headers.refreshToken.rawValue)
        return request
    }
    
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "----------------------------------------------------\n\n[\(method)] \(url)\n\n----------------------------------------------------\n"
        log.append("API: \(target)\n")
        log.append("\n------------------- Network Request Headers -------------------\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header: \(headers)\n")
        }
        log.append("\n------------------- Network Request Body -------------------\n")
        if let body = httpRequest.httpBody, let bodyString = body.toPrettyPrintedString {
            log.append("\(bodyString)\n")
        }
        log.append("------------------- END \(method) --------------------------\n")
        print(log)
    }
    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSuceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
    
    func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "------------------- 네트워크 통신 성공 -------------------"
        log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("API: \(target)\n")
        log.append("\n------------------- Network Response Headers -------------------\n")
        response.response?.allHeaderFields.forEach {
            log.append("\($0): \($1)\n")
        }
        log.append("\n------------------- Network Response Body -------------------\n")
        if let reString = response.data.toPrettyPrintedString {
            log.append("\(reString)\n")
        }
        log.append("------------------- END HTTP (\(response.data.count)-byte body) -------------------")
        print(log)
        
//        if isFromError {
//            do {
//                let errorCode = try JSONDecoder().decode(ErrorCode.self, from: response.data)
//                if errorCode.errorCode == "E06" {
//                    print("Refresh Token is Expired.")
//                    // TODO: - 리프레시 토큰 갱신 트리걸 구현
//                }
//            } catch {
//                print("Decoding Error", error)
//            }
//        }
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuceed(response, target: target, isFromError: true)
            return
        }
        var log = "네트워크 오류"
        log.append("<-- \(error.errorCode) \(target)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP")
        print(log)
    }
}
