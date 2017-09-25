//
//  ReceiptLoader.swift
//  IAPTutorial
//
//  Created by Eric Hodgins on 2017-09-18.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

struct ReceiptLoader {
    let receiptUrl = Bundle.main.appStoreReceiptURL
    
    func loadReceipt() throws -> Data {
        if(receiptFound()) {
            let receiptData = try? Data(contentsOf: receiptUrl!)
            if let receiptData = receiptData {
                return receiptData
            }
        }
        
        throw ReceiptValidationError.couldNotFindReceipt
    }
    
    fileprivate func receiptFound() -> Bool {
        do {
            if let isReachable = try receiptUrl?.checkResourceIsReachable() {
                return isReachable
            }
        } catch _ {
            return false
        }
        
        return false
    }
}
