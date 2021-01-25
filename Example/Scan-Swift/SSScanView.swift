//
//  SSScanView.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/25.
//

import UIKit
import Scan_Swift

class SSScanView: ScanView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        addMarkLayer()
    }
}
