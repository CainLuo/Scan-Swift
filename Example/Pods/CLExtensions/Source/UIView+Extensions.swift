//
//  UIView+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

private func swizzle(_ v: UIView.Type) {
    
    [(#selector(v.traitCollectionDidChange(_:)), #selector(v.ksr_traitCollectionDidChange(_:)))]
        .forEach { original, swizzled in
            
            guard let originalMethod = class_getInstanceMethod(v, original),
                let swizzledMethod = class_getInstanceMethod(v, swizzled) else { return }
            
            let didAddViewDidLoadMethod = class_addMethod(v,
                                                          original,
                                                          method_getImplementation(swizzledMethod),
                                                          method_getTypeEncoding(swizzledMethod))
            
            if didAddViewDidLoadMethod {
                class_replaceMethod(v,
                                    swizzled,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
    }
}

private var hasSwizzled = false

extension UIView {
    @IBInspectable public var layoutImage: UIImage {
        set {
            layer.contents = newValue.cgImage
        }
        get {
            return layer.contents as! UIImage
        }
    }

    final public class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.bindViewModel()
    }
    
    @objc open func bindStyles() {
    }
    
    @objc open func bindViewModel() {
    }
    
    @objc internal func ksr_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection) {
        self.ksr_traitCollectionDidChange(previousTraitCollection)
        self.bindStyles()
    }
}
