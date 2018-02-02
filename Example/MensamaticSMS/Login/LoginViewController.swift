//
//  LoginViewController.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 2/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

class LoginViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //-------------------------------------
    // MARK: - SIGN IN
    //-------------------------------------
    @IBAction func doSignIn(_ sender: UIButton) {
        guard let userName = self.userTextField.text, let pass = self.passwordTextField.text else { return }
        
        sms_authentication(user: userName, password: pass) { (result) in
            switch result {
            case .successWithData( _):
                self.performSegue(withIdentifier: "MainSegue", sender: nil)
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
        }
    }
    
    //--------------------------------------------------------
    // MARK: Prepare For Segue
    //--------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? MainViewController {
            
        }
    }
    
}
