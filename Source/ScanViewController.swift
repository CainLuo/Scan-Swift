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
    func scanViewControllerDrawed(_ vc: ScanViewController)
}

open class ScanViewController: UIViewController {
    
    open var scanManager: ScanManager?
    
    open var delegate: ScanViewControllerDelegate?
    
    private var scanView: ScanView!
    
    @IBInspectable public var loading = "loading"
    
    // 启动区域识别功能
    @IBInspectable open var isResetScanRect = false
    
    // 是否需要识别后的当前图像
    @IBInspectable public var isNeedCodeImage = false

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if scanView == nil {
            scanView = ScanView(frame: UIScreen.main.bounds)
            view.addSubview(scanView!)
            delegate?.scanViewControllerDrawed(self)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startScan()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scanManager?.stop()
    }
}

extension ScanViewController {
    @objc open func startScan() {
        if scanManager == nil {
            var rect = CGRect.zero
            if isResetScanRect {
                rect = scanView.getScanRect()
            }
            scanManager = ScanManager(view, isCaptureImage: isNeedCodeImage, cropRect: rect)
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
