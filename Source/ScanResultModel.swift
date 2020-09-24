//
//  ScanResultModel.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import UIKit
import AVFoundation

public struct ScanResultModel {
    
    public var content: String?
    public var image: UIImage?
    public var codeType: AVMetadataObject.ObjectType?
    public var scanCorner: [CGPoint]?
    
    public init(content: String?, image: UIImage?, codeType: AVMetadataObject.ObjectType?, scanCorner: [CGPoint]?) {
        self.content = content
        self.image = image
        self.codeType = codeType
        self.scanCorner = scanCorner
    }
}
