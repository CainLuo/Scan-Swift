//
//  IBDesignableView.swift
//  CLExtensions
//
//  Created by Cain Luo on 2020/2/10.
//  Copyright © 2020 Cain Luo. All rights reserved.
//

import UIKit

@IBDesignable open class IBDesignableView: UIView {
    @IBInspectable public var cornerRadius: CGFloat = 0.0
    @IBInspectable public var borderColor: UIColor = .clear
    @IBInspectable public var borderWidth: CGFloat = 0.0
    
    public override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = (cornerRadius > 0)
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        super.draw(rect)
    }
}
