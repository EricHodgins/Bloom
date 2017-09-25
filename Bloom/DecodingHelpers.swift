//
//  DecodingHelpers.swift
//  IAPTutorial
//
//  Created by Eric Hodgins on 2017-09-19.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

func DecodeASN1Integer(startOfInt intPointer: inout UnsafePointer<UInt8>?, length: Int) -> Int? {
    // These will be set by ASN1_get_object
    var type = Int32(0)
    var xclass = Int32(0)
    var intLength = 0
    
    ASN1_get_object(&intPointer, &intLength, &type, &xclass, length)
    
    guard type == V_ASN1_INTEGER else {
        return nil
    }
    
    let integer = c2i_ASN1_INTEGER(nil, &intPointer, intLength)
    let result = ASN1_INTEGER_get(integer)
    ASN1_INTEGER_free(integer)
    
    return result
}

func DecodeASN1String(startOfString stringPointer: inout UnsafePointer<UInt8>?, length: Int) -> String? {
    // These will be set by ASN1_get_object
    var type = Int32(0)
    var xclass = Int32(0)
    var stringLength = 0
    
    ASN1_get_object(&stringPointer, &stringLength, &type, &xclass, length)
    
    if type == V_ASN1_UTF8STRING {
        let mutableStringPointer = UnsafeMutableRawPointer(mutating: stringPointer!)
        return String(bytesNoCopy: mutableStringPointer, length: stringLength, encoding: String.Encoding.utf8, freeWhenDone: false)
    }
    
    if type == V_ASN1_IA5STRING {
        let mutableStringPointer = UnsafeMutableRawPointer(mutating: stringPointer!)
        return String(bytesNoCopy: mutableStringPointer, length: stringLength, encoding: String.Encoding.ascii, freeWhenDone: false)
    }
    
    return nil
}

func DecodeASN1Date(startOfDate datePointer: inout UnsafePointer<UInt8>?, length: Int) -> Date? {
    // Date formatter code from https://www.objc.io/issues/17-security/receipt-validation/#parsing-the-receipt
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    if let dateString = DecodeASN1String(startOfString: &datePointer, length:length) {
        return dateFormatter.date(from: dateString)
    }
    
    return nil
}
