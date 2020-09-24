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
            output.rectOfInterest = cropRect
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
        if !session.isRunning {
            configure.isNeedScanResult = true
            session.startRunning()
        }
    }
    
    func stop() {
        if session.isRunning {
            configure.isNeedScanResult = false
            session.stopRunning()
        }
    }
    
    open func scanImage() {
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
    }
}

// MARK: Flash Config
extension ScanManager {
    // 修改闪光灯的开或关
    open func changeFlash() {
        let isOpenFlash = input?.device.torchMode == .off
        openFlash(isOpenFlash)
    }

    private func isCanOpenFlash() -> Bool {
        return device != nil && device!.hasFlash && device!.hasTorch
    }

    private func openFlash(_ torch: Bool) {
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
                            scanCorner: nil)
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
    public static func createCodeImage(_ codeType: ScanManagerCodeType, content: String, size: CGSize, codeColor: UIColor = .black, backgroundColor: UIColor = .white) -> UIImage? {
        let data = content.data(using: .utf8)
        
        let qrFilter = CIFilter(name: codeType.rawValue)
        qrFilter?.setValue(data, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
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

// MARK: Logo Code Image
extension ScanManager {
    public static func addLogoToCode(_ code: UIImage, logo: UIImage, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(code.size)
        code.draw(in: CGRect(x: 0, y: 0, width: code.size.width, height: code.size.height))
        
        let rect = CGRect(x: code.size.width / 2 - size.width / 2,
                          y: code.size.height / 2 - size.height / 2,
                          width: size.width,
                          height: size.height)
        
        logo.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
