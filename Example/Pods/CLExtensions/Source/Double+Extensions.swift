//
//  Double+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import Foundation

extension Double {
    public var oneDecimal: String {
        return String(format: self == 0 ? "%.0f" : "%0.1f" , self)
    }
    
    public var twoDecimal: String {
        return String(format: self == 0 ? "%.0f" : "%0.2f" , self)
    }
}
