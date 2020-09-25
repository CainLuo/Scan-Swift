//
//  NSObject+Extensions.swift
//  CLExtensions
//
//  Created by Cain Luo on 2020/4/19.
//  Copyright © 2020 Cain Luo. All rights reserved.
//

import Foundation

extension NSObject {
    public class var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return type(of: self).className
    }
}
