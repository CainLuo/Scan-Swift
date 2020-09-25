//
//  ScanManager.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import UIKit
import AVFoundation

public protocol ScanManagerDelegate: class {
    func scanManagerScanImage(_ manager: ScanManager, results: [ScanResultModel])
}

open class ScanManager: NSObject {
        
    open weak var delegate: ScanManagerDelegate?
    
    let device = AVCaptureDevice.default(for: .video)
    
    var input: AVCaptureDeviceInput!
    var output: AVCaptureMetadataOutput!

    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var stillImageOutput: AVCaptureStillImageOutput!
    
    public var results: [ScanResultModel] = []
    public var configure = ScanConfigure.shared
    
    init(_ view: UIView, isCaptureImage: Bool, cropRect: CGRect = .zero) {
        #if TARGET_IPHONE_SIMULATOR  //模拟器
        return
        #endif
        
        configure.isNeedCaptureImage = isCaptureImage
        
        stillImageOutput = AVCaptureStillImageOutput()
        output = AVCaptureMetadataOutput()
        super.init()
        guard let device = device else { return }
        
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            #if DEBUG
            print("Capture device input initialize fail: \(error.localizedDescription)")
            #endif
        }
        
        guard let input = input else { return }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
        
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = configure.codeTypes
                
        if !cropRect.equalTo(.zero) {
            // 在相机启动后再修改则无任何效果
            #if DEBUG
            print("after cropRect: \(cropRect), output.rectOfInterest: \(output.rectOfInterest)")
            #endif
            output.rectOfInterest = cropRect
            #if DEBUG
            print("before cropRect: \(cropRect), output.rectOfInterest: \(output.rectOfInterest)")
            #endif
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        
        if let layer = previewLayer {
            view.layer.insertSublayer(layer, at: 0)
        }
        
        if device.isFocusPointOfInterestSupported &&
            device.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try input.device.lockForConfiguration()
                input.device.focusMode = .continuousAutoFocus
                input.device.unlockForConfiguration()
            } catch {
                #if DEBUG
                print("Device lock for configuration fail: \(error)")
                #endif
            }
        }
    }
}

// MARK: Scan Control
extension ScanManager {
    func start() {
        #if TARGET_IPHONE_SIMULATOR  //模拟器
        return
        #endif
        if !session.isRunning {
            configure.isNeedScanResult = true
            session.startRunning()
        }
    }
    
    func stop() {
        #if TARGET_IPHONE_SIMULATOR  //模拟器
        return
        #endif
        if session.isRunning {
            configure.isNeedScanResult = false
            session.stopRunning()
        }
    }
    
    private func scanImage() {
        guard let connections = stillImageOutput?.connections,
              let still = createConnection(.video, connections: connections) else { return }
        
        stillImageOutput?.captureStillImageAsynchronously(from: still, completionHandler: { [weak self] (buffer, error) in
            guard let weakSelf = self else { return }
            weakSelf.stop()
            
            if let buffer = buffer,
               let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
                
                let image = UIImage(data: data)
                
                for index in 0...weakSelf.results.count - 1 {
                    self?.results[index].image = image
                }
            }
            
            if let delegate = weakSelf.delegate {
                delegate.scanManagerScanImage(weakSelf, results: weakSelf.results)
            }
        })
    }
    
    private func createConnection(_ type: AVMediaType, connections: [AVCaptureConnection]) -> AVCaptureConnection? {
        for connection in connections {
            for port in connection.inputPorts where port.mediaType == type {
                return connection
            }
        }
                
        return nil
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension ScanManager: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        guard configure.isNeedScanResult else { return }
        
        configure.isNeedScanResult = false
        results.removeAll()
        
        for obj in metadataObjects {
            guard let code = obj as? AVMetadataMachineReadableCodeObject else { continue }
            results.append(ScanResultModel(content: code.stringValue,
                                           image: nil,
                                           codeType: code.type,
                                           obj: code))
        }
        
        if results.isEmpty {
            configure.isNeedScanResult = true
        } else {
            if configure.isNeedCaptureImage {
                scanImage()
            } else {
                stop()
                #if DEBUG
                print("Scan Results: \(results)")
                #endif
                delegate?.scanManagerScanImage(self, results: results)
            }
        }
    }
}

// MARK: Flash Config
extension ScanManager {
    // 修改闪光灯的开或关
    open func changeFlash() {
        #if TARGET_IPHONE_SIMULATOR  //模拟器
        return
        #endif
        let isOpenFlash = input?.device.torchMode == .off
        openFlash(isOpenFlash)
    }

    private func isCanOpenFlash() -> Bool {
        return device != nil && device!.hasFlash && device!.hasTorch
    }

    private func openFlash(_ torch: Bool) {
        #if TARGET_IPHONE_SIMULATOR  //模拟器
        return
        #endif
        guard isCanOpenFlash() else { return }
        do {
            try input?.device.lockForConfiguration()
            input?.device.torchMode = torch ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
            input?.device.unlockForConfiguration()
        } catch {
            #if DEBUG
            print("Open Flash Fail: \(error.localizedDescription)")
            #endif
        }
    }
}

// MARK: Recognize Image QR Code
extension ScanManager {
    public static func recognizeImage(_ image: UIImage) -> [ScanResultModel] {
        guard let cgImage = image.cgImage else { return [] }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let ciImage = CIImage(cgImage: cgImage)
        let features = detector.features(in: ciImage, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let hasFeatures = features.filter { $0.isKind(of: CIQRCodeFeature.self) }
        let codeFeature = hasFeatures.map { $0 as! CIQRCodeFeature }
        
        return codeFeature.map {
            ScanResultModel(content: $0.messageString,
                            image: image,
                            codeType: .qr,
                            feature: $0)
        }
    }
}

// MARK: Code Types
public enum ScanManagerCodeType: String {
    case aztecCodeGenerator = "CIAztecCodeGenerator"
    case code128 = "CICode128BarcodeGenerator"
    case pdf417 = "CIPDF417BarcodeGenerator"
    case qrCodeGenerator = "CIQRCodeGenerator"
}

extension ScanManager {
    
    /// Create Code Image
    /// - Returns: UIImage
    public static func createCodeImage(_ codeType: ScanManagerCodeType, content: String, size: CGSize,
                                       codeColor: UIColor = .black, backgroundColor: UIColor = .white, isHight: Bool = false) -> UIImage? {
        let data = content.data(using: .utf8)
        
        let qrFilter = CIFilter(name: codeType.rawValue)
        qrFilter?.setValue(data, forKey: "inputMessage")
        
        if isHight {
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        }
        
        let colorFilter = CIFilter(name: "CIFalseColor",
                                   parameters: [
                                       "inputImage": qrFilter!.outputImage!,
                                       "inputColor0": CIColor(cgColor: codeColor.cgColor),
                                       "inputColor1": CIColor(cgColor: backgroundColor.cgColor)])

        guard let qrImage = colorFilter?.outputImage,
        let cgImage = CIContext().createCGImage(qrImage, from: qrImage.extent) else {
            return nil
        }

        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = CGInterpolationQuality.none
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return codeImage
    }
}
