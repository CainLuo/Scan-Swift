//
//  SSScanToolBarView.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/25.
//

import UIKit
import CLExtensions
import Scan_Swift

enum SSScanToolBarViewTypes: Int {
    case qrCode = 0
    case flash
}

protocol SSScanToolBarViewDelegate: class {
    func scanQRToolsViewDidSelect(_ view: SSScanToolBarView, type: SSScanToolBarViewTypes)
    func scanQRToolsViewOpenFlash(_ view: SSScanToolBarView, type: SSScanToolBarViewTypes, isOpen: Bool)
}

class SSScanToolBarView: UIView {
    
    weak var delegate: SSScanToolBarViewDelegate?

    static func instantiate() -> SSScanToolBarView {
        let view = UINib.createViewForm(nibName: "SSScanToolBarView") as! SSScanToolBarView
        return view
    }

    @IBAction func openFlase(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.scanQRToolsViewOpenFlash(self, type: .flash, isOpen: sender.isSelected)
    }
    
    @IBAction func openPhotoLibrary(_ sender: Any) {
        delegate?.scanQRToolsViewDidSelect(self, type: .qrCode)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 150)
            ])
    }
}
