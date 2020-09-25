//
//  UICollectionView+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func register(nibName: String, inBundle bundle: Bundle? = nil) {
        self.register(UINib(nibName: nibName, bundle: bundle),
                      forCellWithReuseIdentifier: nibName)
    }
    
    public func registerCellClass<CellClass: UICollectionViewCell> (_ cellClass: CellClass.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.description())
    }
    
    public func registerCellNibForClass(_ cellClass: AnyClass) {
        let classNameWithoutModule = cellClass
            .description()
            .components(separatedBy: ".")
            .dropFirst()
            .joined(separator: ".")
        
        register(UINib(nibName: classNameWithoutModule, bundle: nil),
                 forCellWithReuseIdentifier: classNameWithoutModule)
    }
}
