//
//  UINavigationController+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func findViewController(_ viewControllerName: String) -> UIViewController? {
        for viewController in viewControllers {
            if let isViewController = NSClassFromString(viewControllerName),
                viewController.isKind(of: isViewController) {
                return viewController
            }
        }
        return nil
    }
    
    public func popToViewControllerWith(_ viewControllerName: String) -> Array<UIViewController>? {
        if let controllerName = findViewController(viewControllerName) {
            return popToViewController(controllerName, animated: true)
        }
        
        return nil
    }
    
    func popToViewControllerWith(_ level: Int, animated: Bool) -> Array<UIViewController>? {
        if level == 0 || self.viewControllers.count < level {
            return self.popToRootViewController(animated: animated)
        } else {
            let index = viewControllers.count - level - 1
            
            if let viewController = viewControllers[safe: index] {
                return popToViewController(viewController, animated: animated)
            }
        }
        
        return nil
    }
}
