//
//  ScanResultModel.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import UIKit

public struct ScanResultModel {
    
    public var content: String?
    public var image: UIImage?
    public var codeType: String?
    public var scanCorner: [Any]?
    
    public init(content: String?, image: UIImage?, codeType: String?, scanCorner: [Any]?) {
        self.content = content
        self.image = image
        self.codeType = codeType
        self.scanCorner = scanCorner
    }
}
