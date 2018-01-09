//
//  ViewController.swift
//  MensamaticSMS
//
//  Created by Juantri on 01/09/2018.
//  Copyright (c) 2018 Juantri. All rights reserved.
//

import UIKit
import MensamaticSMS

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sms_authentication(user: "juantri.jimenez@develapps.com", password: "Develapps16") { (result) in
            switch result {
            case .successWithData(let data):
                print(data ?? "Todo ok")
                
            case .error(let error):
                print(error)
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getAction(_ sender: UIButton) {
        sms_getData { (result) in
            switch result {
            case .successWithData(let data):
                DispatchQueue.main.async {
                    self.textLabel.text = "\(data ?? "data")"
                }
                
            case .error(let error):
                print(error)
                
            }
        }

    }
    
    @IBAction func postAction(_ sender: UIButton) {
        sms_postData { (result) in
            switch result {
            case .successWithData(let data):
                DispatchQueue.main.async {
                    self.textLabel.text = "\(data ?? "Data")"
                }
                
            case .error(let error):
                print(error)
                
            }
        }
        
        

    }
    
}

