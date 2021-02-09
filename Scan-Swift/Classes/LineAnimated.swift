//
//  LineAnimated.swift
//  Scan-Swift
//
//  Created by CainLuo on 2021/2/9.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

open class LineAnimated: UIImageView {
    
    public static let share = LineAnimated()
    
    var isAnimation = false
    var animatedRect: CGRect = .zero
    
    func start(_ rect: CGRect, view: UIView, image: UIImage?) {
        self.image = image
        animatedRect = rect
        
        isHidden = false
        isAnimation = true
        
        if image != nil {
            step()
        }
    }
    
    @objc func step() {
        guard isAnimation, let image = self.image else { return }
        
        let height = image.size.height * animatedRect.size.width / image.size.width
        
        animatedRect.origin.y -= height
        animatedRect.size.height = height
        self.frame = animatedRect
        alpha = 0.0
        
        UIView.animate(withDuration: 1.4, animations: {
            self.alpha = 1.0
            let height = image.size.height * self.animatedRect.size.width / image.size.width
            self.animatedRect.origin.y += (self.animatedRect.size.height - height)
            self.animatedRect.size.height = height
            self.frame = self.animatedRect
        }, completion: { _ in
            self.perform(#selector(LineAnimated.step), with: nil, afterDelay: 0.3)
        })
    }
    
    func stop() {
        isHidden = true
        isAnimation = false
    }
    
    deinit {
        stop()
    }
}
