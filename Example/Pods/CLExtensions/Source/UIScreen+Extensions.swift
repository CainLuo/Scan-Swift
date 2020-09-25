//
//  UIScreen+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

extension UIScreen {
    public var screenWidth: CGFloat {
        return screenSize.width
    }
    
    public var screenHeight: CGFloat {
        return screenSize.height
    }
    
    public var screenSize: CGSize {
        return self.bounds.size
    }
    
    public static func fitScreen(value: CGFloat) -> CGFloat {
        let width = Float(UIScreen.main.bounds.size.width)
        let newValue: Float = Float((value / 2.0))
        if UIDevice.current.model == "iPad" {
            return CGFloat(ceilf(width / 834.0 * newValue))
        } else {
            return CGFloat(ceilf(width / 375.0  * newValue))
        }
    }

    public static func fitPlusScreen(value: CGFloat) -> CGFloat {
        let width = Float(UIScreen.main.bounds.size.width)
        let newValue: Float = Float((value / 2.0))
        if UIDevice.current.model == "iPad" {
            return CGFloat(ceilf(width / 834.0 * newValue))
        } else {
            return CGFloat(ceilf(width / 540.0  * newValue))
        }
    }
}
