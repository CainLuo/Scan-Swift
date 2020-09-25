//
//  UIViewController+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

private func swizzle(_ vc: UIViewController.Type) {
    
    [
        (#selector(vc.viewDidLoad), #selector(vc.ksr_viewDidLoad)),
        (#selector(vc.viewWillAppear(_:)), #selector(vc.ksr_viewWillAppear(_:))),
        (#selector(vc.traitCollectionDidChange(_:)), #selector(vc.ksr_traitCollectionDidChange(_:))),
        ].forEach { original, swizzled in
            
            guard let originalMethod = class_getInstanceMethod(vc, original),
                let swizzledMethod = class_getInstanceMethod(vc, swizzled) else { return }
            
            let didAddViewDidLoadMethod = class_addMethod(vc,
                                                          original,
                                                          method_getImplementation(swizzledMethod),
                                                          method_getTypeEncoding(swizzledMethod))
            
            if didAddViewDidLoadMethod {
                class_replaceMethod(vc,
                                    swizzled,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
    }
}

private var hasSwizzled = false

extension UIViewController {
    
    final public class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
    }
    
    @objc internal func ksr_viewDidLoad() {
        self.ksr_viewDidLoad()
        self.bindViewModel()
    }
    
    @objc internal func ksr_viewWillAppear(_ animated: Bool) {
        self.ksr_viewWillAppear(animated)
        
        if !self.hasViewAppeared {
            self.bindStyles()
            self.hasViewAppeared = true
        }
    }
    
    /**
     The entry point to bind all view model outputs. Called just before `viewDidLoad`.
     */
    @objc open func bindViewModel() {
    }
    
    /**
     The entry point to bind all styles to UI elements. Called just after `viewDidLoad`.
     */
    @objc open func bindStyles() {
    }
    
    @objc public func ksr_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.ksr_traitCollectionDidChange(previousTraitCollection)
        self.bindStyles()
    }
    
    private struct AssociatedKeys {
        static var hasViewAppeared = "hasViewAppeared"
    }
    
    // Helper to figure out if the `viewWillAppear` has been called yet
    private var hasViewAppeared: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.hasViewAppeared) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.hasViewAppeared,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Alert
extension UIViewController {
    
    @discardableResult
    public func showAlert(title: String?, message: String, done: (() -> Void)? = nil) -> UIAlertController {
        return showAlert(title: title, message: message, yesTitle: "OK", noTitle: nil, done: done)
    }
    
    @discardableResult
    public func showAlert(title: String?,
                          message: String,
                          yesTitle: String?,
                          noTitle: String?,
                          done: (() -> Void)?) -> UIAlertController {
        return showAlert(title: title, message: message, yesTitle: yesTitle, noTitle: noTitle, cancel: nil, done: done)
    }
    
    @discardableResult
    public func showAlert(title: String?,
                          message: String,
                          yesTitle: String?,
                          noTitle: String?,
                          cancel: (() -> Void)?,
                          done: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let yesTitle = yesTitle {
            alert.addAction(UIAlertAction(title: yesTitle, style: .default, handler: { (_) in
                done?()
            }))
        }
        
        if let noTitle = noTitle {
            alert.addAction(UIAlertAction(title: noTitle, style: .cancel, handler: { (_) in
                cancel?()
            }))
        }
        
        present(alert, animated: true, completion: nil)
        
        return alert
    }
    
    @discardableResult
    public func showSheet(titles: [String]?, cancelTitle: String?, action: ((_ index: Int) -> Void)?, cancel: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let titles = titles {
            for title in titles {
                alert.addAction(UIAlertAction(title: title, style: .default, handler: { (_) in
                    action?(titles.firstIndex(of: title)!)
                }))
            }
        }
        
        if let noTitle = cancelTitle {
            alert.addAction(UIAlertAction(title: noTitle, style: .cancel, handler: { (_) in
                cancel?()
            }))
        }
                
        present(alert, animated: true, completion: nil)
        
        return alert
    }
}

// MARK: - Storyboard Identifiable
extension UIViewController {
    public static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
    
    public static var defultNib: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}

// MARK: - Back Button
extension UIViewController {
    public func setBackTitleEmpty() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    public func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
}
