//
//  Int+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import Foundation

private let formatter: NumberFormatter = NumberFormatter()

extension Int {
    public func formattedString(style: NumberFormatter.Style, localeIdentifier: String) -> String {
        formatter.numberStyle = style
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter.string(from: self as NSNumber) ?? ""
    }
}

// MARK: Int Translation
extension Int {
    public var asString: String {
        return String(self)
    }
    
    public var asDouble: Double {
        return Double(self)
    }
    
    public var decimalString: String {
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    public func toString() -> String? {
        return String(self)
    }
}
