//
//  UIDevice+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

extension UIDevice {
    public var diveceModel: String {
        return self.model
    }

    public var uuidString: String? {
        return self.identifierForVendor?.uuidString
    }
}
