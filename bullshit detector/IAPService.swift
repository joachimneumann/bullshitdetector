//
//  IAPService.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 06.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import Foundation
import StoreKit

class IAPService: NSObject {
    private override init() {}
    static let shared = IAPService()
    let paymentQueue = SKPaymentQueue.default()
    var priceString: String?
    var products = [SKProduct]()
    
    func getProducts() {
        let products: Set = [IAPProduct.customisation.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({ $0 .productIdentifier == product.rawValue}).first else { return }
        print("to purchase: \(productToPurchase.productIdentifier)")
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        print("restoring purchases")
        paymentQueue.restoreCompletedTransactions()
    }
    
    func priceStringForProduct(product: IAPProduct) -> String? {
        guard let productToFindPriceOf = products.filter({ $0 .productIdentifier == product.rawValue}).first else { return "" }
        let numberFormatter = NumberFormatter()
        let price = productToFindPriceOf.price
        let locale = productToFindPriceOf.priceLocale
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter.string(from: price)
    }
    
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for p in products {
            print("product: \(p.productIdentifier) \(p.localizedTitle)")
        }
        priceString = IAPService.shared.priceStringForProduct(product: .customisation)
        print("price: \(priceString ?? "unknown")")
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(),
                  transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
            if let transactionError = transaction.error as NSError?,
                let localizedDescription = transaction.error?.localizedDescription,
                transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(localizedDescription)")
            }
        }
    }

    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        paymentQueue.finishTransaction(transaction)
    }

    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        paymentQueue.finishTransaction(transaction)
    }

    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func deliverPurchaseNotificationFor(identifier: String?) {
        Model.shared.customizationHasBeenPurchased = true
        NotificationCenter.default.post(name: Notification.Name(customizablePurchasedNotification), object: nil)
    }

    private func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        if UserDefaults.standard.bool(forKey: customizationHasBeenPurchasedKey) {
            return false
        } else {
            return true
        }
    }

}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
            case .deferred:   return "deferred"
            case .failed:     return "failed"
            case .purchased:  return "purchased"
            case .purchasing: return "purchasing"
            case .restored:   return "restored"
        }
    }
}
