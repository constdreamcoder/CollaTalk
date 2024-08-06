//
//  PaymentView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/4/24.
//

import SwiftUI
import UIKit
import iamport_ios

struct PaymentView: UIViewControllerRepresentable {
    
    @EnvironmentObject private var store: AppStore
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = PaymentViewController()
        view.selectedCoinItem = store.state.coinShopState.selectedCoinItem
        view.resultCallback = { reponse in
            print("결제 완료")
            print(String(describing: reponse))
            
            guard let reponse else { return }
            store.dispatch(.coinShopAction(.paymentValidation(paymentResultResponse: reponse)))
        }
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

final class PaymentViewController: UIViewController {
    
    var selectedCoinItem: CoinItem? = nil
    var resultCallback: ((_ response: IamportResponse?) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestIamportPayment()
    }
    
    /// 결제 요청
    private func requestIamportPayment() {
        let payment = createPaymentData()
        
        guard let resultCallback else { return }
        
        Iamport.shared.payment(
            viewController: self,
            userCode: APIKeys.portOneUserCode,
            payment: payment,
            paymentResultCallback: resultCallback
        )
    }
    
    /// 결제 데이터 생성
    private func createPaymentData() -> IamportPayment {
        IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: APIKeys.pgId),
            merchant_uid: "ios_\(APIKeys.sesacKey)_\(Int(Date().timeIntervalSince1970))",
            amount: selectedCoinItem?.amount ?? "").then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = selectedCoinItem?.item ?? ""
                $0.buyer_name = APIKeys.buyerName
                $0.app_scheme = APIKeys.portOneAppScheme
            }
    }
}
