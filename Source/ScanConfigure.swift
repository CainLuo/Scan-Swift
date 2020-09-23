//
//  ScanConfigure.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import Foundation
import AVFoundation

open class ScanConfigure {
    
    let shared = ScanConfigure()
    
    var isNeedCaptureImage = false
    var isNeedScanResult = true
    
    var codeTypes: [AVMetadataObject.ObjectType] = [.qr,
                                                    .upce,
                                                    .code39Mod43,
                                                    .ean13,
                                                    .ean8,
                                                    .code39,
                                                    .code93,
                                                    .code128,
                                                    .pdf417,
                                                    .aztec,
                                                    .interleaved2of5,
                                                    .itf14,
                                                    .dataMatrix]
}
