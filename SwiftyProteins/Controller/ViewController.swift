//
//  ViewController.swift
//  SwiftyProteins
//
//  Created by Jonathan LE QUERE on 10/17/19.
//  Copyright © 2019 Jonathan LE QUERE. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
	
	@IBOutlet weak var loginButtonOutlet: UIButton!
	@IBOutlet weak var subTitleLabel: UILabel!
	
	// BioAuthentication vars
	let myBioContext = LAContext()
	let myLocalizedReasonString = "Biometric Authentication"
	var bioAuthError: NSError?
	var isBioCompatible: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if #available(iOS 8.0, *) {
			if !myBioContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &bioAuthError) {
				print("INFO: Local authentication feature is not activated or is broken.")
				self.loginButtonOutlet.setTitle("Login", for: .normal)
				self.isBioCompatible = false
			} else {
				self.loginButtonOutlet.setTitle("Biometric Login", for: .normal)
				self.isBioCompatible = true
			}
		} else {
			print("INFO: Local authentication feature is not supported.")
			self.loginButtonOutlet.setTitle("Login", for: .normal)
			self.isBioCompatible = false
		}
	}
	
	func displayAlert(title: String, message: String) -> Void {
		let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
		self.present(alert, animated: true)
	}
	
	// ACTIONS
	
	@IBAction func loginButtonAction(_ sender: Any) {
		if self.isBioCompatible == true {
			myBioContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, error in
				DispatchQueue.main.async {
					if success {
						print("User authenticated successfully with biometrics")
//						DISPLAYS PROTEIN LIST VIEW CONTROLLER
						self.performSegue(withIdentifier: "showProteinsListView", sender: self)
					} else {
						print("Sorry user did not authenticate successfully")
						self.displayAlert(title: "Error", message: "Sorry user did not authenticate successfully")
						self.subTitleLabel.text = "Try with your Login & Password"
						self.loginButtonOutlet.setTitle("Login", for: .normal)
						self.isBioCompatible = false
					}
				}
			}
		} else {
			let alert = UIAlertController(title: "Connection", message: "Enter your login and password", preferredStyle: .alert)
			
			alert.addTextField { (loginTextField) in
				loginTextField.clearsOnBeginEditing = true
			}
			alert.addTextField { (passwordTextField) in
				passwordTextField.isSecureTextEntry = true
				passwordTextField.clearsOnBeginEditing = true
			}

			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
			alert.addAction(UIAlertAction(title: "Connect", style: .default, handler: { (_) in
				print("User authenticated successfully with login & password")
//				DISPLAYS PROTEIN LIST VIEW CONTROLLER
				let nextViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "proteinsListViewControllerID") as UIViewController
				self.present(nextViewController, animated: true, completion: nil)
			}))
			
			self.present(alert, animated: true, completion: nil)
		}
	}
}
