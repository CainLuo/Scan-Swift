//
//  NSLayoutConstraint+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

private var NSLayoutConstraintKey = "NSLayoutConstraintKey"

public extension NSLayoutConstraint {

    @IBInspectable var fitConstant: CGFloat {
        set {
            constant = UIScreen.fitScreen(value: newValue)
            objc_setAssociatedObject(self, &NSLayoutConstraintKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let vc = objc_getAssociatedObject(self, &NSLayoutConstraintKey) as? CGFloat {
                return vc
            }
            return constant
        }
    }
        
    @IBInspectable var fitPlusConstant: CGFloat {
        set {
            constant = UIScreen.fitPlusScreen(value: newValue)
            objc_setAssociatedObject(self, &NSLayoutConstraintKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let vc = objc_getAssociatedObject(self, &NSLayoutConstraintKey) as? CGFloat {
                return vc
            }
            return constant
        }
    }
}
