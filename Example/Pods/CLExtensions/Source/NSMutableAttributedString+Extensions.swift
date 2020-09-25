//
//  NSMutableAttributedString+Extensions.swift
//  CLExtensions
//
//  Created by Cain Luo on 2020/2/3.
//  Copyright © 2020 Cain Luo. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    public static func drawImageInAttributedString(content: String, image: UIImage, bounds: CGRect, isPrefix: Bool = true) -> NSMutableAttributedString {
        let attributedString = NSAttributedString(string: content)
        let mutableAttributedString = NSMutableAttributedString()

        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds
        
        let imageAttributed = NSAttributedString(attachment: attachment)
        
        if isPrefix {
            mutableAttributedString.append(imageAttributed)
            mutableAttributedString.append(attributedString)
        } else {
            mutableAttributedString.append(attributedString)
            mutableAttributedString.append(imageAttributed)
        }
        
        return mutableAttributedString
    }
}
