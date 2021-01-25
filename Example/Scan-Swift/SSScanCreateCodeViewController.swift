//
//  SSScanCreateCodeViewController.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/25.
//

import UIKit
import Scan_Swift

class SSScanCreateCodeViewController: UIViewController {
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var logoCodeImageView: UIImageView!
    @IBOutlet weak var code128ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createQRCode()
        create128Code()
        createLogoCode()
    }
}

extension SSScanCreateCodeViewController {
    func createQRCode() {
        qrCodeImageView.image = ScanManager.createCodeImage(.qrCodeGenerator, content: "Hello word", size: qrCodeImageView.frame.size)
    }
    
    func createLogoCode() {
        if let qrCode = ScanManager.createCodeImage(.qrCodeGenerator, content: "天青色等烟雨 而我在等你", size: logoCodeImageView.frame.size) {
            logoCodeImageView.image = ScanImageManager.addLogoToCode(qrCode, logo: UIImage(named: "logo")!, size: CGSize(width: 60, height: 60))
        }
    }
    
    func create128Code() {
        code128ImageView.image = ScanManager.createCodeImage(.code128, content: "000111222333", size: code128ImageView.frame.size)
    }
}
