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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "MENSAMATIC API SMS"
    }

    //-------------------------------------
    // MARK: - Actions
    //-------------------------------------
    @IBAction func openSendView(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SendSegue", sender: nil)
    }
    
    @IBAction func openListSMS(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ListSMSSegue", sender: nil)
    }
    
    @IBAction func getCurrentUserCredits(_ sender: UIButton) {
        sms_currentUserCredits { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any], let credits = json["credits"] as? Int {
                    print(json)
                    self.present(Common().showAlert(title: "Credits", message: "\(credits)"), animated: true, completion: nil)
                } else {
                    self.present(Common().showAlert(title: "Error", message: "There was a problem. Please, try again later."), animated: true, completion: nil)
                }
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
        }
    }
    
    //-------------------------------------
    // MARK: - Prepare for segue
    //-------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendSegue" {
            
        }
    }
    
}
