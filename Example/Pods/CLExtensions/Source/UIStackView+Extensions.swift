//
//  UIStackView+Extensions.swift
//  CLExtensions
//
//  Created by Cain Luo on 2019/12/17.
//  Copyright © 2019 CainLuo. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    @IBInspectable var fitSpacing: CGFloat {
        set {
            spacing = UIScreen.fitScreen(value: newValue)
        }
        get {
            return spacing
        }
    }
    
    @IBInspectable var fitPlusSpacing: CGFloat {
        set {
            spacing = UIScreen.fitScreen(value: newValue)
        }
        get {
            return spacing
        }
    }
}
