//
//  GridImageView.swift
//  Scan-Swift_Example
//
//  Created by CainLuo on 2021/2/9.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

open class GridImageView: UIImageView {
    
    public static func instance() -> GridImageView {
        return GridImageView()
    }
    
    var isAnimation = false
    var animatedRect: CGRect = .zero

    func config(_ rect: CGRect, view: UIView, image: UIImage?) {
        self.image = image
        animatedRect = rect
        view.addSubview(self)
        
        isHidden = false
        isAnimation = true
        
        if image != nil {
            start()
        }
    }
    
    @objc func start() {
        guard isAnimation, let image = self.image else { return }
        
        let height = image.size.height * animatedRect.size.width / image.size.width
        
        animatedRect.origin.y -= height
        animatedRect.size.height = height
        frame = animatedRect
        alpha = 0.0
        
        UIView.animate(withDuration: 1.4, animations: { [weak self] in
            self?.alpha = 1.0
            let height = image.size.height * (self?.animatedRect.size.width ?? 0) / image.size.width
            self?.animatedRect.origin.y += ((self?.animatedRect.size.height ?? 0) - height)
            self?.animatedRect.size.height = height
            self?.frame = self?.animatedRect ?? .zero
        }, completion: { [weak self] _ in
            self?.perform(#selector(GridImageView.start), with: nil, afterDelay: 0.3)
        })
    }
    
    func stop() {
        isHidden = true
        isAnimation = false
    }
    
    deinit {
        stop()
        #if DEBUG
        print("-------------------------------------- GridImageView deinit --------------------------------------")
        #endif
    }
}
