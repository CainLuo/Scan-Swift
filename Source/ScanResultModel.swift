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
    public var obj: AVMetadataMachineReadableCodeObject?
    public var feature: CIQRCodeFeature?
    
    public init(content: String?, image: UIImage?, codeType: AVMetadataObject.ObjectType?,
                obj: AVMetadataMachineReadableCodeObject? = nil, feature: CIQRCodeFeature? = nil) {
        self.content = content
        self.image = image
        self.codeType = codeType
        self.obj = obj
        self.feature = feature
    }
}
