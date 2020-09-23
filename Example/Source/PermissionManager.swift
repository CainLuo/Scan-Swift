//
//  PermissionManager.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import UIKit
import AVFoundation
import Photos
import AssetsLibrary

class PermissionManager {
    
    //MARK: 获取相册权限
    static func authorizePhotoWith(comletion: @escaping (Bool, PHAuthorizationStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            comletion(true, status)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { authorization in
                DispatchQueue.main.async {
                    comletion(authorization == .authorized, status)
                }
            }
        default:
            comletion(false, status)
        }
    }
    
    //MARK: 相机权限
    static func authorizeCameraWith(completion: @escaping (Bool, AVAuthorizationStatus) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion(true, status)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isAccess in
                DispatchQueue.main.async {
                    completion(isAccess, status)
                }
            }
        default:
            completion(false, status)
        }
    }
    
    //MARK: 跳转到APP系统设置权限界面
    static func jumpToSystemPrivacySetting() {
        let appSetting = URL(string: UIApplication.openSettingsURLString)!
        if #available(iOS 10, *) {
            UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appSetting)
        }
    }
}
