//
//  ReceiptParser.swift
//  IAPTutorial
//
//  Created by Eric Hodgins on 2017-09-19.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

struct ReceiptParser {
    func parse(_ PKCS7Container: UnsafeMutablePointer<PKCS7>) throws -> ParsedReceipt {
        var bundleIdentifier: String?
        var bundleIdData: NSData?
        var appVersion: String?
        var opaqueValue: NSData?
        var sha1Hash: NSData?
        var inAppPurchaseReceipts = [ParsedInAppPurchaseReceipt]()
        var originalAppVersion: String?
        var receiptCreationDate: Date?
        var expirationDate: Date?
        
        // Parse the receipt, setting each variable
        
        // Strategy Step 1: Preliminary structure checks
        
        // Must have data to work with
        guard let contents = PKCS7Container.pointee.d.sign.pointee.contents, let octets = contents.pointee.d.data else {
            throw ReceiptValidationError.malformedReceipt
        }
        
        // Determine the start and end of the receipt payload
        var currentASN1PayloadLocation = UnsafePointer(octets.pointee.data)
        let endOfPayload = currentASN1PayloadLocation!.advanced(by: Int(octets.pointee.length))
        
        var type = Int32(0)
        var xclass = Int32(0)
        var length = 0
        
        ASN1_get_object(&currentASN1PayloadLocation, &length, &type, &xclass,Int(octets.pointee.length))
        
        // Payload must be an ASN1 Set
        guard type == V_ASN1_SET else {
            throw ReceiptValidationError.malformedReceipt
        }
        
        // Decode Payload
        // Strategy Step 2: Walk through payload (ASN1 Set) and parse each ASN1 Sequence
        // within (ASN1 Sets contain one or more ASN1 Sequences)
        while currentASN1PayloadLocation! < endOfPayload {
            
            // Get next ASN1 Sequence
            ASN1_get_object(&currentASN1PayloadLocation, &length, &type, &xclass, currentASN1PayloadLocation!.distance(to: endOfPayload))
            
            // ASN1 Object type must be an ASN1 Sequence
            guard type == V_ASN1_SEQUENCE else {
                throw ReceiptValidationError.malformedReceipt
            }
            
            // Attribute type of ASN1 Sequence must be an Integer
            guard let attributeType = DecodeASN1Integer(startOfInt: &currentASN1PayloadLocation, length: currentASN1PayloadLocation!.distance(to: endOfPayload)) else {
                throw ReceiptValidationError.malformedReceipt
            }
            
            // Attribute version of ASN1 Sequence must be an Integer
            guard DecodeASN1Integer(startOfInt: &currentASN1PayloadLocation, length: currentASN1PayloadLocation!.distance(to: endOfPayload)) != nil else {
                throw ReceiptValidationError.malformedReceipt
            }
            
            // Get ASN1 Sequence value
            ASN1_get_object(&currentASN1PayloadLocation, &length, &type, &xclass, currentASN1PayloadLocation!.distance(to: endOfPayload))
            
            // ASN1 Sequence value must be an ASN1 Octet String
            guard type == V_ASN1_OCTET_STRING else {
                throw ReceiptValidationError.malformedReceipt
            }
            
            // Strategy Step 3: Decode attributes
            switch attributeType {
            case 2:
                var startOfBundleId = currentASN1PayloadLocation
                bundleIdData = NSData(bytes: startOfBundleId, length: length)
                bundleIdentifier = DecodeASN1String(startOfString: &startOfBundleId, length: length)
            case 3:
                var startOfAppVersion = currentASN1PayloadLocation
                appVersion = DecodeASN1String(startOfString: &startOfAppVersion, length: length)
            case 4:
                let startOfOpaqueValue = currentASN1PayloadLocation
                opaqueValue = NSData(bytes: startOfOpaqueValue, length: length)
            case 5:
                let startOfSha1Hash = currentASN1PayloadLocation
                sha1Hash = NSData(bytes: startOfSha1Hash, length: length)
            case 17:
                var startOfInAppPurchaseReceipt = currentASN1PayloadLocation
                let iapReceipt = try parseInAppPurchaseReceipt(currentInAppPurchaseASN1PayloadLocation: &startOfInAppPurchaseReceipt, payloadLength: length)
                inAppPurchaseReceipts.append(iapReceipt)
            case 12:
                var startOfReceiptCreationDate = currentASN1PayloadLocation
                receiptCreationDate = DecodeASN1Date(startOfDate: &startOfReceiptCreationDate, length: length)
            case 19:
                var startOfOriginalAppVersion = currentASN1PayloadLocation
                originalAppVersion = DecodeASN1String(startOfString: &startOfOriginalAppVersion, length: length)
            case 21:
                var startOfExpirationDate = currentASN1PayloadLocation
                expirationDate = DecodeASN1Date(startOfDate: &startOfExpirationDate, length: length)
            default:
                break
            }
            
            currentASN1PayloadLocation = currentASN1PayloadLocation?.advanced(by: length)
        }
        
        // Strategy Step 4: Return ParsedReceipt
        
        return ParsedReceipt(bundleIdentifier: bundleIdentifier,
                             bundleIdData: bundleIdData,
                             appVersion: appVersion,
                             opaqueValue: opaqueValue,
                             sha1Hash: sha1Hash,
                             inAppPurchaseReceipts: inAppPurchaseReceipts,
                             originalAppVersion: originalAppVersion,
                             receiptCreationDate: receiptCreationDate,
                             expirationDate: expirationDate)
    }
    
    func parseInAppPurchaseReceipt(currentInAppPurchaseASN1PayloadLocation: inout UnsafePointer<UInt8>?, payloadLength: Int) throws -> ParsedInAppPurchaseReceipt {
        var quantity: Int?
        var productIdentifier: String?
        var transactionIdentifier: String?
        var originalTransactionIdentifier: String?
        var purchaseDate: Date?
        var originalPurchaseDate: Date?
        var subscriptionExpirationDate: Date?
        var cancellationDate: Date?
        var webOrderLineItemId: Int?
        
        // Parse the in-app purchase receipt, setting each variable
        // Find the end of the in-app purchase receipt payload
        let endOfPayload = currentInAppPurchaseASN1PayloadLocation!.advanced(by: payloadLength)
        var type = Int32(0)
        var xclass = Int32(0)
        var length = 0
        
        ASN1_get_object(&currentInAppPurchaseASN1PayloadLocation, &length, &type, &xclass, payloadLength)
        
        // Payload must be an ASN1 Set
        guard type == V_ASN1_SET else {
            throw ReceiptValidationError.malformedInAppPurchaseReceipt
        }
        
        // Decode Payload
        // Step through payload (ASN1 Set) and parse each ASN1 Sequence within (ASN1 Sets contain one or more ASN1 Sequences)
        while currentInAppPurchaseASN1PayloadLocation! < endOfPayload {
            
            // Get next ASN1 Sequence
            ASN1_get_object(&currentInAppPurchaseASN1PayloadLocation, &length, &type, &xclass, currentInAppPurchaseASN1PayloadLocation!.distance(to: endOfPayload))
            
            // ASN1 Object type must be an ASN1 Sequence
            guard type == V_ASN1_SEQUENCE else {
                throw ReceiptValidationError.malformedInAppPurchaseReceipt
            }
            
            // Attribute type of ASN1 Sequence must be an Integer
            guard let attributeType = DecodeASN1Integer(startOfInt: &currentInAppPurchaseASN1PayloadLocation, length: currentInAppPurchaseASN1PayloadLocation!.distance(to: endOfPayload)) else {
                throw ReceiptValidationError.malformedInAppPurchaseReceipt
            }
            
            // Attribute version of ASN1 Sequence must be an Integer
            guard DecodeASN1Integer(startOfInt: &currentInAppPurchaseASN1PayloadLocation, length: currentInAppPurchaseASN1PayloadLocation!.distance(to: endOfPayload)) != nil else {
                throw ReceiptValidationError.malformedInAppPurchaseReceipt
            }
            
            // Get ASN1 Sequence value
            ASN1_get_object(&currentInAppPurchaseASN1PayloadLocation, &length, &type, &xclass, currentInAppPurchaseASN1PayloadLocation!.distance(to: endOfPayload))
            
            // ASN1 Sequence value must be an ASN1 Octet String
            guard type == V_ASN1_OCTET_STRING else {
                throw ReceiptValidationError.malformedInAppPurchaseReceipt
            }
            
            // Decode attributes
            switch attributeType {
            case 1701:
                var startOfQuantity = currentInAppPurchaseASN1PayloadLocation
                quantity = DecodeASN1Integer(startOfInt: &startOfQuantity , length: length)
            case 1702:
                var startOfProductIdentifier = currentInAppPurchaseASN1PayloadLocation
                productIdentifier = DecodeASN1String(startOfString: &startOfProductIdentifier, length: length)
            case 1703:
                var startOfTransactionIdentifier = currentInAppPurchaseASN1PayloadLocation
                transactionIdentifier = DecodeASN1String(startOfString: &startOfTransactionIdentifier, length: length)
            case 1705:
                var startOfOriginalTransactionIdentifier = currentInAppPurchaseASN1PayloadLocation
                originalTransactionIdentifier = DecodeASN1String(startOfString: &startOfOriginalTransactionIdentifier, length: length)
            case 1704:
                var startOfPurchaseDate = currentInAppPurchaseASN1PayloadLocation
                purchaseDate = DecodeASN1Date(startOfDate: &startOfPurchaseDate, length: length)
            case 1706:
                var startOfOriginalPurchaseDate = currentInAppPurchaseASN1PayloadLocation
                originalPurchaseDate = DecodeASN1Date(startOfDate: &startOfOriginalPurchaseDate, length: length)
            case 1708:
                var startOfSubscriptionExpirationDate = currentInAppPurchaseASN1PayloadLocation
                subscriptionExpirationDate = DecodeASN1Date(startOfDate: &startOfSubscriptionExpirationDate, length: length)
            case 1712:
                var startOfCancellationDate = currentInAppPurchaseASN1PayloadLocation
                cancellationDate = DecodeASN1Date(startOfDate: &startOfCancellationDate, length: length)
            case 1711:
                var startOfWebOrderLineItemId = currentInAppPurchaseASN1PayloadLocation
                webOrderLineItemId = DecodeASN1Integer(startOfInt: &startOfWebOrderLineItemId, length: length)
            default:
                break
            }
            
            currentInAppPurchaseASN1PayloadLocation = currentInAppPurchaseASN1PayloadLocation!.advanced(by: length)
        }
        
        return ParsedInAppPurchaseReceipt(quantity: quantity,
                                          productIdentifier: productIdentifier,
                                          transactionIdentifier: transactionIdentifier,
                                          originalTransactionIdentifier: originalTransactionIdentifier,
                                          purchaseDate: purchaseDate,
                                          originalPurchaseDate: originalPurchaseDate,
                                          subscriptionExpirationDate: subscriptionExpirationDate,
                                          cancellationDate: cancellationDate,
                                          webOrderLineItemId: webOrderLineItemId)
    }
}















