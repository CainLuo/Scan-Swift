//
//  IBDesignableLabel.swift
//  CLExtensions
//
//  Created by Cain Luo on 2020/2/10.
//  Copyright © 2020 Cain Luo. All rights reserved.
//

import UIKit

@IBDesignable open class IBDesignableLabel: UILabel {
    
    @IBInspectable var tipsImage: UIImage?
    @IBInspectable var isPrefix: Bool = true
    @IBInspectable var hightLightText: String?
    @IBInspectable var hightLightColor: UIColor = .black

    override open func draw(_ rect: CGRect) {
        if let tipsImage = tipsImage,
            let text = text {
            let iconRect = CGRect(x: 0,
                                  y: UIScreen.fitPlusScreen(value: -8),
                                  width: UIScreen.fitPlusScreen(value: 50),
                                  height: UIScreen.fitPlusScreen(value: 50))

            attributedText = NSMutableAttributedString.drawImageInAttributedString(content: text,
                                                                                   image: tipsImage,
                                                                                   bounds: iconRect,
                                                                                   isPrefix: isPrefix)
        }
        
        if let hightLightText = hightLightText {
            drawLabelHightLightText(hightLightText)
        }
        
        super.draw(rect)
    }
    
    public func drawLabelHightLightText(_ hightLightText: String) {
        if let text = text {
            let contentString: NSString = text as NSString
            let mutableAttributedString = NSMutableAttributedString(string: contentString as String)
            
            mutableAttributedString.addAttributes([.foregroundColor: hightLightColor],
                                                  range: contentString.range(of: hightLightText))
            
            attributedText = mutableAttributedString
        }
    }
}
