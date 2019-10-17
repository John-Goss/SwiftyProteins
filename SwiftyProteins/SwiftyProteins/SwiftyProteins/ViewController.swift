//
//  ViewController.swift
//  SwiftyProteins
//
//  Created by Jonathan LE QUERE on 10/17/19.
//  Copyright © 2019 Jonathan LE QUERE. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    var isSuccessBioLogin: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // ACTIONS
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let myBioContext = LAContext()
        let myLocalizedReasonString = "Biometric Authentication"
        
        var authError: NSError?
        if #available(iOS 8.0, *) {
            if myBioContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myBioContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, error in
                    
                    DispatchQueue.main.async {
                        if success {
                            self.isSuccessBioLogin = "User authenticated successfully"
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            self.isSuccessBioLogin = "Sorry user did not authenticate successfully"
                        }
                        print(self.isSuccessBioLogin)
                    }
                }
            } else { // Could not evaluate policy; look at authError and present an appropriate message to user
                self.isSuccessBioLogin = "Sorry could not evaluate policy."
            }
        } else { // Fallback on earlier versions
            self.isSuccessBioLogin = "This feature is not supported."
        }
        print(self.isSuccessBioLogin)
    }
    
}
