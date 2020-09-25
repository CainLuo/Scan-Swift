//
//  Array+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    public mutating func remove(object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
    
    public mutating func replaceFirst(object: Element) {
        if let index = self.firstIndex(of: object) {
            self[index] = object
        }
    }
    
    public mutating func replace<C : Collection>(newElements: C) where C.Iterator.Element == Element {
        newElements.forEach {
            self.replaceFirst(object: $0)
        }
    }
    
    public mutating func replacePlus<C : Collection>(newElements: C) where C.Iterator.Element == Element {
        newElements.forEach {
            if self.contains($0) {
                self.replaceFirst(object: $0)
            } else {
                self.append($0)
            }
        }
    }
    
    public mutating func merge<C : Collection>(newElements: C) where C.Iterator.Element == Element{
        let filteredList = newElements.filter({!self.contains($0)})
        self.append(contentsOf: filteredList)
    }

    public mutating func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

extension Array {
    public init(plist: String) {
        guard let path = Bundle.main.path(forResource: plist, ofType: "plist") else {
            self = []
            return
        }
        
        self = NSArray(contentsOfFile: path) as! Array<Element>
    }
}
