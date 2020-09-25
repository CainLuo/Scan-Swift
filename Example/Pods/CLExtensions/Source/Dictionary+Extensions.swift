//
//  Dictionary+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import Foundation

extension Dictionary {
    public init(plist: String) {
        guard let path = Bundle.main.path(forResource: plist, ofType: "plist") else {
            self = [:]
            return
        }
        
        self = NSDictionary(contentsOfFile: path) as! Dictionary<Key, Value>
    }
}

// MARK: Dictionary Merge
public func += <K,V> (left: inout Dictionary<K,V>, right: Dictionary<K,V>?) {
    guard let right = right else { return }
    right.forEach { key, value in
        left.updateValue(value, forKey: key)
    }
}

public func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
    -> Dictionary<K,V>
{
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}
