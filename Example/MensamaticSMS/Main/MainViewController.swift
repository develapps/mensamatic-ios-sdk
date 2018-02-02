//
//  MainViewController.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 2/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

class MainViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var listSentSMSLabel: UILabel!
    @IBOutlet weak var listIncomingSMSLabel: UILabel!
    @IBOutlet weak var currentUserCreditsLabel: UILabel!
    
    var scheduledSMS: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //-------------------------------------
    // MARK: - Actions
    //-------------------------------------
    @IBAction func openSendView(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SendSegue", sender: nil)
    }
    
    //-------------------------------------
    // MARK: - Prepare for segue
    //-------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendSegue" {
            
        }
    }
    
    //-------------------------------------
    // MARK: - Backend
    //-------------------------------------
    
    //-------------------------------------
    // MARK: - SEND SMS
    //-------------------------------------
    @IBAction func sendSMS(_ sender: UIButton) {
        guard let phone = self.phoneTextField.text else { return }
        
        sms_sendSMS(destination: "+34\(phone)", body: "Testing message body", source: "MENSAMATIC", date: nil) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                }
                
            case .error(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
                
            }
        }
        
    }
    
    //-------------------------------------
    // MARK: - SEND UNICODE SMS
    //-------------------------------------
    @IBAction func sendUnicodeSMS(_ sender: UIButton) {
        guard let phone = self.phoneTextField.text else { return }
        
        sms_sendUnicodeSMS(destination: "+34\(phone)", body: "Testing message body € ç", source: "MENSAMATIC", date: nil) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                }
                
            case .error(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
                
            }
        }
    }
    
    //-------------------------------------
    // MARK: - SEND CERTIFICATED SMS
    //-------------------------------------
    @IBAction func sendCertificatedSMS(_ sender: UIButton) {
        guard let phone = self.phoneTextField.text else { return }
        
        sms_sendCertificatedSMS(destination: "+34\(phone)", body: "Testing message body certificated", source: "MENSAMATIC", typeSMS: nil, receipt: nil, date: nil) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                }
                
            case .error(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
                
            }
        }
    }
    
    //-------------------------------------
    // MARK: - LIST SENT SMS
    //-------------------------------------
    @IBAction func listSentSMS(_ sender: UIButton) {
        //Paginated?
    }
    
    //-------------------------------------
    // MARK: - LIST INCOMING SMS
    //-------------------------------------
    @IBAction func listIncomingSMS(_ sender: UIButton) {
        
    }
    
    //-------------------------------------
    // MARK: - SEND 2WAY SMS
    //-------------------------------------
    @IBAction func send2waySMS(_ sender: UIButton) {
        guard let phone = self.phoneTextField.text else { return }
        
        sms_send2WaySMS(destination: "+34\(phone)", body: "Testing message body 2waySMS", source: "+34666999888", unicode: nil, date: nil) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                }
                
            case .error(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
                
            }
        }
    }
    
    //-------------------------------------
    // MARK: - CALCULATE COST PER SMS
    //-------------------------------------
    @IBAction func calculateCostPerSMS(_ sender: UIButton) {
        sms_calculateCostPerSMS(body: "", unicode: nil, type: nil) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                }
                
            case .error(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
                
            }
        }
    }
    
    //-------------------------------------
    // MARK: - CANCEL SCHEDULED SMS
    //-------------------------------------
    @IBAction func cancelScheduledSMS(_ sender: UIButton) {
        if let id = self.scheduledSMS {
            sms_cancelScheduledSMS(id: id, completion: { (result) in
                switch result {
                case .successWithData(let data):
                    if let json = data as? [String:Any] {
                        print(json)
                    }
                    
                case .error(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    
                }
            })
        }
    }
    
    //-------------------------------------
    // MARK: - CURRENT USER CREDITS
    //-------------------------------------
    @IBAction func currentUserCredits(_ sender: UIButton) {
        sms_currentUserCredits { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                }
                
            case .error(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
                
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "Accept", style: .default) { (action) in
            
        }
        alert.addAction(acceptButton)
        
        self.present(alert, animated: true) {
            
        }
    }
    
}
