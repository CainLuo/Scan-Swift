//
//  ScanImageManager.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/24.
//

import UIKit

// MARK: Image Processing
class ScanImageManager {
    
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
