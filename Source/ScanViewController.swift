//
//  ScanViewController.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import UIKit
import AVFoundation

public protocol ScanViewControllerDelegate: class {
    func scanViewControllerDidScan(_ vc: ScanViewController, result: ScanResultModel?, error: Error?)
}

open class ScanViewController: UIViewController {
    
    open var scanManager: ScanManager?
    
    open var delegate: ScanViewControllerDelegate?
    
    public var loading = "loading"
    
    // 启动区域识别功能
    open var isOpenInterestRect = false
    
    // 是否需要识别后的当前图像
    public var isNeedCodeImage = false

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startScan()
        }
    }
}

extension ScanViewController {
    @objc open func startScan() {
        if scanManager == nil {
            scanManager = ScanManager(view, isCaptureImage: isNeedCodeImage, cropRect: view.bounds)
            scanManager?.delegate = self
        }
        
        scanManager?.start()
    }
}

extension ScanViewController: ScanManagerDelegate {
    public func scanManagerScanImage(_ manager: ScanManager, results: [ScanResultModel]) {
        guard let result = results.first else {
            delegate?.scanViewControllerDidScan(self, result: nil, error: scanError(.empty, message: "Empty Content"))
            return
        }
        delegate?.scanViewControllerDidScan(self, result: result, error: nil)
    }
}
