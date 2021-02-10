//
//  ScanView.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/24.
//

import UIKit

open class ScanView: UIView {
    
    var lineAnimated: LineImageView?
    var gridAnimated: GridImageView?
    var indicatorView: UIActivityIndicatorView?
    var isAnimationing = false
    
    // MARK: Config Mark Layer
    public func addMarkLayer() {
        let blackPath = UIBezierPath(rect: frame)
        let emptyPath = UIBezierPath(roundedRect: getPathRect(), cornerRadius: 0).reversing()
        
        blackPath.append(emptyPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = blackPath.cgPath
        
        layer.mask = shapeLayer
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
//        lineAnimated = LineImageView.instance()
        gridAnimated = GridImageView.instance()
        addMarkLayer()
        start()
    }
    
    deinit {
        #if DEBUG
        print("-------------------------------------- ScanView deinit --------------------------------------")
        #endif
    }
}

extension ScanView {
    func start() {
        guard !isAnimationing  else { return }
        isAnimationing = true

        let rect = getPathRect()
        
//        lineAnimated?.config(rect, view: superview!, image: UIImage(named: "qrcode_scan_light_green"))
        gridAnimated?.config(rect, view: superview!, image: UIImage(named: "qrcode_scan_full_net"))
    }
    
    func stop() {
        isAnimationing = false
        lineAnimated?.stop()
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
