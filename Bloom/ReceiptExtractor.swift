//
//  ReceiptExtractor.swift
//  IAPTutorial
//
//  Created by Eric Hodgins on 2017-09-18.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

struct ReceiptExtractor {
    func extractPKCS7Container(_ receiptData: Data) throws -> UnsafeMutablePointer<PKCS7> {
        // use Open SSL to extract the PKCS7 container
        // throw a ReceiptValidationError if something goes wrong in this process
        let receiptBIO = BIO_new(BIO_s_mem())
        BIO_write(receiptBIO, (receiptData as NSData).bytes, Int32(receiptData.count))
        let receiptPKCS7Container = d2i_PKCS7_bio(receiptBIO, nil)
        
        guard receiptPKCS7Container != nil else {
            throw ReceiptValidationError.emptyReceiptContents
        }
        
        let pkcs7DataTypeCode = OBJ_obj2nid(pkcs7_d_sign(receiptPKCS7Container).pointee.contents.pointee.type)
        
        guard pkcs7DataTypeCode == NID_pkcs7_data else {
            throw ReceiptValidationError.emptyReceiptContents
        }
        
        return receiptPKCS7Container!
    }
}
