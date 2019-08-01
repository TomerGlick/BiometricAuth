//
//  ViewController.swift
//  BiometricAuth
//
//  Created by Tomer Glick New on 31/07/2019.
//  Copyright © 2019 Tomer Glick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblSupportStatus: UILabel!
    @IBOutlet weak var lblAuthStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onCheckSupport(_ sender: Any) {
        lblSupportStatus.text = BiometricAuth.supportedBiometricType().rawValue
    }
    
    @IBAction func onDoAuth(_ sender: Any) {
        lblAuthStatus.text = ""
        
        BiometricAuth.isValidUser(reason: "Test Auth") {[unowned self] (success, error) in
            if success {
                self.lblAuthStatus.text = "success"
            } else {
                if let reason = error?.description {
                    self.lblAuthStatus.text = "failed with reason " + reason
                } else {
                    self.lblAuthStatus.text = "failed"
                }
            }
        }
    }
    
}

