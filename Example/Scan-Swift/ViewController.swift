//
//  ViewController.swift
//  Scan-Swift
//
//  Created by YYKJ0048 on 2020/9/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pushToScan(_ sender: Any) {
        let vc = ScanViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

