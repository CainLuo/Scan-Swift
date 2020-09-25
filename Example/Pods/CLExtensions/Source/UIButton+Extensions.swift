//
//  UIButton+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable public var fitFont: CGFloat {
        set {
            titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.fitScreen(value: newValue))
        }
        get {
            return titleLabel?.font.pointSize ?? 17
        }
    }
    
    @IBInspectable public var fitPlusFont: CGFloat {
        set {
            titleLabel?.font = UIFont.systemFont(ofSize: UIScreen.fitPlusScreen(value: newValue))
        }
        get {
            return titleLabel?.font.pointSize ?? 17
        }
    }
    
    @IBInspectable public var fitBoldFont: CGFloat {
        set {
            titleLabel?.font = UIFont.boldSystemFont(ofSize: UIScreen.fitScreen(value: newValue))
        }
        get {
            return titleLabel?.font.pointSize ?? 17
        }
    }
    
    @IBInspectable public var fitPlusBoldFont: CGFloat {
        set {
            titleLabel?.font = UIFont.boldSystemFont(ofSize: UIScreen.fitPlusScreen(value: newValue))
        }
        get {
            return titleLabel?.font.pointSize ?? 17
        }
    }
    
    @IBInspectable public var numberOfLines: Int {
        set {
            titleLabel?.numberOfLines = newValue
        }
        get {
            return self.titleLabel?.numberOfLines ?? 1
        }
    }
    
    @IBInspectable public var adjustsFontSizeToFitWidth: Bool {
        set {
            titleLabel?.adjustsFontSizeToFitWidth = newValue
        }
        get {
            return self.titleLabel?.adjustsFontSizeToFitWidth ?? false
        }
    }
}
