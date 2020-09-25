//
//  UILabel+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable public var fitFont: CGFloat {
        set {
            font = UIFont.systemFont(ofSize: UIScreen.fitScreen(value: newValue))
        }
        get {
            return font.pointSize
        }
    }
    
    @IBInspectable public var fitPlusFont: CGFloat {
        set {
            font = UIFont.systemFont(ofSize: UIScreen.fitPlusScreen(value: newValue))
        }
        get {
            return font.pointSize
        }
    }
    
    @IBInspectable public var fitBoldFont: CGFloat {
        set {
            font = UIFont.boldSystemFont(ofSize: UIScreen.fitScreen(value: newValue))
        }
        get {
            return font.pointSize
        }
    }
    
    @IBInspectable public var fitPlusBoldFont: CGFloat {
        set {
            font = UIFont.boldSystemFont(ofSize: UIScreen.fitPlusScreen(value: newValue))
        }
        get {
            return font.pointSize
        }
    }
}
