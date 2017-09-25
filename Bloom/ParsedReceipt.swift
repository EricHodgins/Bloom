//
//  ParsedReceipt.swift
//  IAPTutorial
//
//  Created by Eric Hodgins on 2017-09-19.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

struct ParsedReceipt {
    let bundleIdentifier: String?
    let bundleIdData: NSData?
    let appVersion: String?
    let opaqueValue: NSData?
    let sha1Hash: NSData?
    let inAppPurchaseReceipts: [ParsedInAppPurchaseReceipt]?
    let originalAppVersion: String?
    let receiptCreationDate: Date?
    let expirationDate: Date?
}

struct ParsedInAppPurchaseReceipt {
    let quantity: Int?
    let productIdentifier: String?
    let transactionIdentifier: String?
    let originalTransactionIdentifier: String?
    let purchaseDate: Date?
    let originalPurchaseDate: Date?
    let subscriptionExpirationDate: Date?
    let cancellationDate: Date?
    let webOrderLineItemId: Int?
}
