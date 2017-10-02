//
//  IAPManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-14.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import StoreKit

protocol IAPManagerDelegate: class {
    func productsRequestResponseCompleted()
}

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    private override init() {}
    
    var request: SKProductsRequest!
    var products: [SKProduct] = []
    
    weak var delegate: IAPManagerDelegate?
    var isCSVPurchased: Bool = false
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        validateReceipt()
        delegate?.productsRequestResponseCompleted()
        
        for product in self.products {
            print(product.localizedTitle)
        }
    }
    
    func getProductIdentifiers() -> [String] {
        var identifiers: [String] = []
        
        if let fileURL = Bundle.main.url(forResource: "products", withExtension: "plist") {
            let products = NSArray(contentsOf: fileURL)
            
            for product in products as! [String] {
                identifiers.append(product)
            }
        }
        
        return identifiers
    }
    
    func performProductRequestForIdentifiers(identifiers: [String]) {
        let products = NSSet(array: identifiers) as! Set<String>
        
        self.request = SKProductsRequest(productIdentifiers: products)
        self.request.delegate = self
        self.request.start()
    }
    
    func requestProducts() {
        self.performProductRequestForIdentifiers(identifiers: getProductIdentifiers())
        SKPaymentQueue.default().add(self)
    }
    
    func setupPurchases(_ handler: @escaping (Bool) -> Void) {
        if SKPaymentQueue.canMakePayments() {
            handler(true)
            
            SKPaymentQueue.default().add(self)
            return
        }
        handler(false)
    }
    
    func createPaymentRequestForProduct(product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        payment.quantity = 1
        
        SKPaymentQueue.default().add(payment)
    }
    
    //MARK: - Transaction Observer
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing")
                break
            case . purchased:
                print("Purchased")
                validateReceipt()
                queue.finishTransaction(transaction)
                break
            case .deferred:
                // DO not block UI here.  THis is for family sharing and this delegate method will be called at another time. (SKMutablePayment.simulatesAskToBuyInSandbox to simulate)
                print("Deferred")
                break
            case .failed:
                print("Failed")
                queue.finishTransaction(transaction)
                break
            case .restored:
                print("Restored")
                queue.finishTransaction(transaction)
                break
            }
        }
    }
    
    private func validateReceipt() {
        let receiptValidator = ReceiptValidator()
        let validationResult = receiptValidator.validateReceipt()
        switch validationResult {
        case .success(let parsedReceipt):
            print("Success")
            guard let purchaseReceipts = parsedReceipt.inAppPurchaseReceipts else {
                print("No IAP receipts.")
                return
            }
            // Unlock features
            for purchase in purchaseReceipts {
                print(purchase.productIdentifier ?? "no identifier...")
                if let product = purchase.productIdentifier,
                    product == "com.csvexporter.com" {
                    isCSVPurchased = true
                }
            }
            break
        case .error(let receiptError):
            print("Error: \(receiptError)")
            break
        }
    }

}




















