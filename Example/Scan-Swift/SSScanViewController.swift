//
//  SSScanViewController.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/25.
//

import UIKit

class SSScanViewController: ScanViewController {
    
    let toolBarView = SSScanToolBarView.instantiate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBarView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(toolBarView)
    }
}

extension SSScanViewController: SSScanToolBarViewDelegate {
    func scanQRToolsViewDidSelect(_ view: SSScanToolBarView, type: SSScanToolBarViewTypes) {
        PermissionManager.authorizePhotoWith { [weak self] _,_  in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true, completion: nil)
        }
    }
    
    func scanQRToolsViewOpenFlash(_ view: SSScanToolBarView, type: SSScanToolBarViewTypes, isOpen: Bool) {
        scanManager?.changeFlash()
    }
}

extension SSScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let image = editedImage ?? originalImage else { return }
        
        let result = ScanManager.recognizeImage(image)
        
        print("识别的结果是: \(result)")
    }
}
