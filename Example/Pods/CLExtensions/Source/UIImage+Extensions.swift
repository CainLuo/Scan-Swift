//
//  UIImage+Extensions.swift
//  CLExtensions
//
//  Created by Cain Luo on 2020/1/22.
//  Copyright © 2020 CainLuo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public static func drawImage(size: CGSize, image: UIImage, completion: @escaping ((UIImage) -> Void)) {
        DispatchQueue.global().async {
            UIGraphicsBeginImageContext(size)
            
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                if let drawImage = drawImage {
                    completion(drawImage)
                }
            }
        }
    }
}
