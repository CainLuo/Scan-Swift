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
    open var indicatorView: UIActivityIndicatorView?
    open var scanView: UIView!
        
    // 启动区域识别功能
    public var isResetScanRect = false
    
    // 是否需要识别后的当前图像
    public var isNeedCodeImage = false

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        #if !TARGET_IPHONE_SIMULATOR  // 判断不是模拟器
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startScan()
        }
        #endif
        super.viewDidAppear(animated)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configIndicatorView()
        configScanView()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scanManager?.stop()
    }
    
    deinit {
        #if DEBUG
        print("-------------------------------------- ScanViewController deinit --------------------------------------")
        #endif
    }
}

// MARK: Start Scan
extension ScanViewController {
    @objc public func startScan() {
        if scanManager == nil {
            var rect = CGRect.zero
            if isResetScanRect, let scanView = scanView as? ScanView {
                rect = scanView.getScanRect()
            }
            scanManager = ScanManager(view, isCaptureImage: isNeedCodeImage, cropRect: rect)
            scanManager?.delegate = self
        }
        
        scanManager?.start()
        indicatorView?.removeFromSuperview()
    }
}

// MARK: ScanManagerDelegate
extension ScanViewController: ScanManagerDelegate {
    public func scanManagerScanImage(_ manager: ScanManager, results: [ScanResultModel]) {
        guard let result = results.first else {
            delegate?.scanViewControllerDidScan(self, result: nil, error: scanError(.empty, message: "Empty Content"))
            return
        }
        delegate?.scanViewControllerDidScan(self, result: result, error: nil)
    }
}

// MARK: Config Indicator View
extension ScanViewController {
    func configIndicatorView() {
        if indicatorView == nil {
            let rect = view.frame
            indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: 30,
                                                                  height: 30))
            indicatorView?.center = CGPoint(x: rect.size.width / 2, y: rect.size.width / 2)
            indicatorView?.style = .whiteLarge
            view.addSubview(indicatorView!)
        }
        indicatorView?.startAnimating()
    }
}

// MARK: Config Scan View
extension ScanViewController {
    func configScanView() {
        let hsaScanView = view.subviews.filter { $0.isKind(of: ScanView.self) }.count > 0
        
        if !hsaScanView {
            if scanView == nil {
                scanView = ScanView(frame: UIScreen.main.bounds)
            }
            view.addSubview(scanView)
            delegate?.scanViewControllerDrawed(self)
        }
    }
}
