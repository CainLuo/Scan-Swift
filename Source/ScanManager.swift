//
//  ScanManager.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import Foundation
import AVFoundation

open class ScanManager: NSObject {
    
    let device = AVCaptureDevice.default(for: .video)
    
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?

    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var stillImageOutput: AVCaptureStillImageOutput?
    
    var results: [ScanResultModel] = []

    
}

// MARK: Scan Control
extension ScanManager {
    func start() {
        if !session.isRunning {
            
            session.startRunning()
        }
    }
    
    func stop() {
        if session.isRunning {
            
            session.stopRunning()
        }
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension ScanManager: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
    }
}
