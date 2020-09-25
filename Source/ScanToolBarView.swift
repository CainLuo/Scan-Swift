//
//  ScanToolBarView.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/25.
//

import UIKit

open class ScanToolBarView: UIView {
        
    public var stackView: UIStackView = {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 80
        let y = UIScreen.main.bounds.height - height

        let stackView = UIStackView(frame: CGRect(x: 0, y: y, width: width, height: height))
        return stackView
    }()
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = superview else { return }
        backgroundColor = .white

        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.2)
            ])
    }
}
