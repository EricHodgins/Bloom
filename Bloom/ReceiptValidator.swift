//
//  ReceiptValidator.swift
//  IAPTutorial
//
//  Created by Eric Hodgins on 2017-09-18.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

enum ReceiptValidationError : Error {
    case couldNotFindReceipt
    case emptyReceiptContents
    case receiptNotSigned
    case appleRootCertificateNotFound
    case receiptSignatureInvalid
    case malformedReceipt
    case malformedInAppPurchaseReceipt
    case incorrectHash
}

enum ReceiptValidationResult {
    case success(ParsedReceipt)
    case error(ReceiptValidationError)
}

struct ReceiptValidator {
    let receiptLoader = ReceiptLoader()
    let receiptExtractor = ReceiptExtractor()
    let receiptSignatureValidator = ReceiptSignatureValidator()
    let receiptParser = ReceiptParser()
    
    func validateReceipt() -> ReceiptValidationResult {
        do {
            let receiptData = try receiptLoader.loadReceipt()
            let receiptContainer = try receiptExtractor.extractPKCS7Container(receiptData)
            
            try receiptSignatureValidator.checkSignaturePresence(receiptContainer)
            try receiptSignatureValidator.checkSignatureAuthenticity(receiptContainer)
            
            
            let parsedReceipt = try receiptParser.parse(receiptContainer)
            try validateHash(receipt: parsedReceipt)
            
            return .success(parsedReceipt)
        } catch {
            return .error(error as! ReceiptValidationError)
        }
    }

    fileprivate func validateHash(receipt: ParsedReceipt) throws {
        // Make sure that the ParsedReceipt instances has non-nil values needed for hash comparison
        // Make sure that the ParsedReceipt instances has non-nil values needed for hash comparison
        guard let receiptOpaqueValueData = receipt.opaqueValue else { throw ReceiptValidationError.incorrectHash }
        guard let receiptBundleIdData = receipt.bundleIdData else { throw ReceiptValidationError.incorrectHash }
        guard let receiptHashData = receipt.sha1Hash else { throw ReceiptValidationError.incorrectHash }
        
        var deviceIdentifier = UIDevice.current.identifierForVendor?.uuid
        
        let rawDeviceIdentifierPointer = withUnsafePointer(to: &deviceIdentifier, {
            (unsafeDeviceIdentifierPointer: UnsafePointer<uuid_t?>) -> UnsafeRawPointer in
            return UnsafeRawPointer(unsafeDeviceIdentifierPointer)
        })
        
        let deviceIdentifierData = NSData(bytes: rawDeviceIdentifierPointer, length: 16)
        
        // Compute the hash for your app & device
        
        // Set up the hasing context
        var computedHash = Array<UInt8>(repeating: 0, count: 20)
        var sha1Context = SHA_CTX()
        
        SHA1_Init(&sha1Context)
        SHA1_Update(&sha1Context, deviceIdentifierData.bytes, deviceIdentifierData.length)
        SHA1_Update(&sha1Context, receiptOpaqueValueData.bytes, receiptOpaqueValueData.length)
        SHA1_Update(&sha1Context, receiptBundleIdData.bytes, receiptBundleIdData.length)
        SHA1_Final(&computedHash, &sha1Context)
        
        let computedHashData = NSData(bytes: &computedHash, length: 20)
        
        // Compare the computed hash with the receipt's hash
        guard computedHashData.isEqual(to: receiptHashData as Data) else { throw ReceiptValidationError.incorrectHash }
        
    }
}





















