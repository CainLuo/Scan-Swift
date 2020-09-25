//
//  SSScanView.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/25.
//

import UIKit
import CLExtensions

class SSScanView: ScanView {
    
    let toolBarView = SSScanToolBarView.instantiate()
        
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        addSubview(toolBarView)
    }
}
