//
//  IBDesignableTextField.swift
//  CLExtensions
//
//  Created by Cain Luo on 2020/2/10.
//  Copyright © 2020 Cain Luo. All rights reserved.
//

import UIKit

@IBDesignable open class IBDesignableTextField: UITextField {
    @IBInspectable var placeholderColor: UIColor = .clear

    open override func drawPlaceholder(in rect: CGRect) {
        let placeholserAttributes = [NSAttributedString.Key.foregroundColor : placeholderColor,
                                     NSAttributedString.Key.font : self.font]
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: placeholserAttributes as [NSAttributedString.Key : Any])
        
        super.drawPlaceholder(in: rect)
    }
}
