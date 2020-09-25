//
//  UITextView+Extensions.swift
//  CLExtensions
//
//  Created by Cain Luo on 2019/12/17.
//  Copyright © 2019 CainLuo. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    @IBInspectable var fitFont: CGFloat {
        set {
            font = UIFont.systemFont(ofSize: UIScreen.fitScreen(value: newValue))
        }
        get {
            if let pointSize = font?.pointSize {
                return pointSize
            }
            return 17
        }
    }
    
    @IBInspectable var fitPlusFont: CGFloat {
        set {
            font = UIFont.systemFont(ofSize: UIScreen.fitPlusScreen(value: newValue))
        }
        get {
            if let pointSize = font?.pointSize {
                return pointSize
            }
            return 17
        }
    }
}
