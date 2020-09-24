//
//  ScanView.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/24.
//

import UIKit

class ScanView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        let path = UIBezierPath(rect: frame)
        let emptyPath = UIBezierPath(roundedRect: CGRect(x: frame.origin.x, y: frame.origin.y, width: 200, height: 200), cornerRadius: 8).reversing()
        
        path.append(emptyPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        layer.mask = shapeLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
