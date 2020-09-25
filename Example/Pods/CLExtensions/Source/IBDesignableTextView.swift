//
//  IBDesignableTextView.swift
//  CLExtensions
//
//  Created by Cain Luo on 2020/2/10.
//  Copyright © 2020 Cain Luo. All rights reserved.
//

import UIKit

private var maxLengths = [UITextView: Int]()
private var minLengths = [UITextView: Int]()

@IBDesignable open class IBDesignableTextView: UITextView, UITextViewDelegate {
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
            delegate = self
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > maxLength,
            let text = textView.text {
            let startIndex = text.index(textView.text.startIndex, offsetBy: 0)
            let endIndex = text.index(textView.text.startIndex, offsetBy: maxLength)
            textView.text = String(text[startIndex ..< endIndex])
        }
    }
}
