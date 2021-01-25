//
//  ScanError.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import Foundation

public enum ScanErrorType: Int {
    case empty = -1
    case unknown = -2
}

public func scanError(_ code: ScanErrorType, message: String? = nil) -> NSError {
    let domain = "com.scan-swift.error"
    let userInfo: [String : Any] = [NSLocalizedDescriptionKey: message ?? ""]
    return NSError(domain: domain, code: code.rawValue, userInfo: userInfo)
}
