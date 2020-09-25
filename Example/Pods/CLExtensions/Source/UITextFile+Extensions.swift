//
//  UITextFile+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

private var maxLengths = [UITextField: Int]()
private var minLengths = [UITextField: Int]()

extension UITextField {
    public func checkLength(max: Int) {
        guard let text = text else {
            return
        }
        
        if text.count > max {
            self.text = String(text.prefix(max))
        }
    }
}

extension UITextField {
    @IBInspectable public var minLength: Int {
        get {
            guard let length = minLengths[self] else {
                return 0
            }
            
            return length
        }
        set {
            minLengths[self] = newValue
        }
    }
    
    @IBInspectable public var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            
            return length
        }
        set {
            maxLengths[self] = newValue
            
            addTarget(self,
                      action: #selector(limitLength),
                      for: .editingChanged)
        }
    }
    
    @objc public func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
            return
        }
        
        textField.text = String(prospectiveText.prefix(maxLength))
    }
}

extension UITextField {
    @IBInspectable public var fitFont: CGFloat {
        set {
            font = UIFont.systemFont(ofSize: UIScreen.fitScreen(value: newValue))
        }
        get {
            return font?.pointSize ?? 17
        }
    }
    
    @IBInspectable public var fitPlusFont: CGFloat {
        set {
            font = UIFont.systemFont(ofSize: UIScreen.fitPlusScreen(value: newValue))
        }
        get {
            return font?.pointSize ?? 17
        }
    }
    
    @IBInspectable public var fitBoldFont: CGFloat {
        set {
            font = UIFont.boldSystemFont(ofSize: UIScreen.fitScreen(value: newValue))
        }
        get {
            return font?.pointSize ?? 17
        }
    }
    
    @IBInspectable public var fitPlusBoldFont: CGFloat {
        set {
            font = UIFont.boldSystemFont(ofSize: UIScreen.fitPlusScreen(value: newValue))
        }
        get {
            return font?.pointSize ?? 17
        }
    }
}
