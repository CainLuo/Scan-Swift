//
//  ScanView.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/24.
//

import UIKit

open class ScanView: UIView {
    
    // 镂空的UIBezierPath
    public var emptyPath: UIBezierPath!
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview != nil else { return }
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        let path = UIBezierPath(rect: frame)
        emptyPath = UIBezierPath(roundedRect: getPathRect(), cornerRadius: 0).reversing()
        
        path.append(emptyPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        layer.mask = shapeLayer
    }
}

// MARK: Config Rects
extension ScanView {
    
    open func getPathRect() -> CGRect {
        let width = UIScreen.main.bounds.width
        let pathSize = width * 0.75
        let x = (width - pathSize) / 2

        return CGRect(x: x, y: x, width: pathSize, height: pathSize)
    }
    
    // ref:http://www.cocoachina.com/ios/20141225/10763.html
    open func getScanRect() -> CGRect {

        var rectOfInterest = CGRect.zero

        let cropRect = getPathRect()
        let size = self.bounds.size
        let p1 = size.height / size.width

        // Use 1080p Image Input
        let p2: CGFloat = 1920.0 / 1080.0
        if p1 < p2 {
            let fixHeight = size.width * 1920.0 / 1080.0
            let fixPadding = (fixHeight - size.height) / 2
            rectOfInterest = CGRect(x: (cropRect.origin.y + fixPadding) / fixHeight,
                                    y: cropRect.origin.x / size.width,
                                    width: cropRect.size.height / fixHeight,
                                    height: cropRect.size.width / size.width)

        } else {
            let fixWidth = size.height * 1080.0 / 1920.0
            let fixPadding = (fixWidth - size.width) / 2
            rectOfInterest = CGRect(x: cropRect.origin.y / size.height,
                                    y: (cropRect.origin.x + fixPadding) / fixWidth,
                                    width: cropRect.size.height / size.height,
                                    height: cropRect.size.width / fixWidth)
        }

        return rectOfInterest
    }
}
