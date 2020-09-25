//
//  UINib+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

extension UINib {
    public class func createViewForm(nibName: String, identifier: String? = nil) -> UIView {
        var bundle = Bundle.main
        
        if let identifier = identifier,
           let bundleIdentifier = Bundle(identifier: identifier) {
            bundle = bundleIdentifier
        }
        
        return UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

// MARK: UIView
extension UIView {
    public func view(fromNib nib: String) -> UIView? {
        return UINib(nibName: nib, bundle: nil).instantiate(withOwner: self, options: nil).first
            as? UIView
    }
    
    public static func fromNib(nib: String) -> UIView? {
        guard let view = UINib(nibName: nib, bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? UIView else {
                assertionFailure("Nib not found")
                return nil
        }

        return view
    }
}

// MARK: CustomNib
public protocol CustomNib {
    associatedtype CustomNibType
    
    static func fromNib(nib: String) -> CustomNibType?
}

extension CustomNib {
    public static func fromNib(nib: String) -> Self? {
        guard let view = UINib(nibName: nib, bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? Self else {
                assertionFailure("Nib not found")
                return nil
        }

        return view
    }
}
