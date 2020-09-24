//
//  ScanManager.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import UIKit
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
                                       "inputColor1": CIColor(cgColor: backgroundColor.cgColor),
                                   ]
        )

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

// MARK: Image Processing
extension ScanManager {
    
    /// Scale Code Image
    /// - Parameters:
    ///   - image: UIImage
    ///   - quality: CGInterpolationQuality
    ///   - rate: CGFloat
    /// - Returns: UIImage
    public static func scale(_ image: UIImage, quality: CGInterpolationQuality, rate: CGFloat) -> UIImage? {
        var scaleImage: UIImage?
        let size = CGSize(width: image.size.width * rate,
                          height: image.size.height * rate)

        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = quality
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaleImage
    }
    
    /// Cut Image
    /// - Parameters:
    ///   - image: UIImage
    ///   - rect: CGRect
    /// - Returns: UIImage
    public static func cut(_ image: UIImage, rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    /// Rotation
    /// - Parameters:
    ///   - image: UIImage
    ///   - orientation: UIImage.Orientation
    /// - Returns: UIImage
    public static func rotation(_ image: UIImage, orientation: UIImage.Orientation) -> UIImage? {
        var rotate: Double = 0.0
        var rect: CGRect
        var translateX: CGFloat = 0.0
        var translateY: CGFloat = 0.0
        var scaleX: CGFloat = 1.0
        var scaleY: CGFloat = 1.0

        switch orientation {
        case .left:
            rotate = .pi / 2
            rect = CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width)
            translateX = 0
            translateY = -rect.size.width
            scaleY = rect.size.width / rect.size.height
            scaleX = rect.size.height / rect.size.width
        case .right:
            rotate = 3 * .pi / 2
            rect = CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width)
            translateX = -rect.size.height
            translateY = 0
            scaleY = rect.size.width / rect.size.height
            scaleX = rect.size.height / rect.size.width
        case .down:
            rotate = .pi
            rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            translateX = -rect.size.width
            translateY = -rect.size.height
        default:
            rotate = 0.0
            rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            translateX = 0
            translateY = 0
        }

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        // CTM translate
        context.translateBy(x: 0.0, y: rect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.rotate(by: CGFloat(rotate))
        context.translateBy(x: translateX, y: translateY)

        context.scaleBy(x: scaleX, y: scaleY)
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
        
        let contentImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return contentImage
    }
}
