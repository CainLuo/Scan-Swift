//
//  LineAnimated.swift
//  Scan-Swift
//
//  Created by CainLuo on 2021/2/9.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

open class LineAnimated: UIImageView {
    
    public static func instance() -> LineAnimated {
        return LineAnimated()
    }
    
    private var isAnimation = false
    var animatedRect: CGRect = .zero
    
    func config(_ rect: CGRect, view: UIView, image: UIImage?) {
        self.image = image
        animatedRect = rect
        if !view.subviews.contains(self) {
            view.addSubview(self)
        }
        
        isHidden = false
        isAnimation = true
        
        if image != nil {
            start()
        }
    }
    
    @objc func start() {
        guard isAnimation, let image = self.image else { return }
        
        var rect = animatedRect
        rect.size.height = image.size.height
        frame = rect
        alpha = 0.0
        
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
            self?.alpha = 1.0
            var rect = self?.animatedRect
            rect?.origin.y += ((self?.animatedRect.height ?? 0) - image.size.height)
            rect?.size.height = image.size.height
            self?.frame = rect ?? .zero
        }, completion: { [weak self] _ in
            self?.perform(#selector(LineAnimated.start), with: nil, afterDelay: 0.3)
        })
    }
    
    func stop() {
        isHidden = true
        isAnimation = false
    }
    
    deinit {
        stop()
        #if DEBUG
        print("-------------------------------------- LineAnimated deinit --------------------------------------")
        #endif
    }
}
