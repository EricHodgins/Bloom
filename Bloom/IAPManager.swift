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

class IAPManager: NSObject, SKProductsRequestDelegate {
    static let shared = IAPManager()
    private override init() {}
    
    var request: SKProductsRequest!
    var products: [SKProduct] = []
    
    weak var delegate: IAPManagerDelegate?
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
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
    }
    
    func setupPurchases(_ handler: @escaping (Bool) -> Void) {
        if SKPaymentQueue.canMakePayments() {
            handler(true)
            return
        }
        handler(false)
    }
}




















