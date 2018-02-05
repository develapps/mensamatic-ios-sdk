//
//  SendViewController.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 2/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

class SendViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateSelectedLabel: UILabel!
    @IBOutlet weak var sourceTextField: UITextField!
    
    let datePicker = UIDatePicker()
    var dateSelected: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Send SMS"
        
        self.bodyTextView.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
        self.bodyTextView.layer.borderWidth = 1.0
        self.bodyTextView.layer.cornerRadius = 4
        self.bodyTextView.clipsToBounds = true
        self.bodyTextView.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneText))
        toolbar.setItems([doneButton], animated: false)
        
        self.phoneTextField.inputAccessoryView = toolbar
        self.bodyTextView.inputAccessoryView = toolbar
        self.sourceTextField.inputAccessoryView = toolbar
        self.sourceTextField.delegate = self
        
        self.dateSelectedLabel.text = ""

        //Formate Date
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.minimumDate = Date()
    }

    //-------------------------------------
    // MARK: - Text view Delegate
    //-------------------------------------
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textOfTextView = textView.text else { return true }
        let newLength = textOfTextView.count + text.count - range.length
        return newLength <= 140
    }
    
    //-------------------------------------
    // MARK: - Text field Delegate
    //-------------------------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == self.sourceTextField {
            return newLength <= 11
        }
        return true
    }
    
    //-------------------------------------
    // MARK: - Actions
    //-------------------------------------
    @IBAction func openDatePicker(_ sender: UIButton) {
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        self.dateTextField.inputAccessoryView = toolbar
        self.dateTextField.inputView = self.datePicker
        self.dateTextField.becomeFirstResponder()
    }
    
    @objc func doneText(){
        self.phoneTextField.resignFirstResponder()
        self.bodyTextView.resignFirstResponder()
        self.sourceTextField.resignFirstResponder()
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.dateSelectedLabel.text = formatter.string(from: self.datePicker.date)
        self.dateSelected = self.datePicker.date
        self.dateTextField.resignFirstResponder()
    }
    
    @objc func cancelDatePicker(){
        self.dateSelectedLabel.text = ""
        self.dateSelected = nil
        self.dateTextField.resignFirstResponder()
    }
    
    //-------------------------------------
    // MARK: - SEND SMS
    //-------------------------------------
    @IBAction func sendSMS(_ sender: UIButton) {
        self.doneText()
        guard let phone = self.phoneTextField.text, phone != "", self.bodyTextView.text != "", let source = self.sourceTextField.text, source != "" else {
            self.present(Common().showAlert(title: "Error", message: "Phone, message and sender are compulsory"), animated: true, completion: nil)
            return
        }
        
        sms_sendSMS(destination: "\(phone)", body: self.bodyTextView.text, source: source, date: self.dateSelected) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    self.jsonTreatment(json: json)
                }
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
        }
        
    }
    
    //-------------------------------------
    // MARK: - SEND UNICODE SMS
    //-------------------------------------
    @IBAction func sendUnicodeSMS(_ sender: UIButton) {
        self.doneText()
        guard let phone = self.phoneTextField.text, phone != "", self.bodyTextView.text != "", let source = self.sourceTextField.text, source != "" else {
            self.present(Common().showAlert(title: "Error", message: "Phone, message and sender are compulsory"), animated: true, completion: nil)
            return
        }
        
        sms_sendUnicodeSMS(destination: "\(phone)", body: self.bodyTextView.text, source: source, date: self.dateSelected) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    self.jsonTreatment(json: json)
                }
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
        }
    }
    
    //-------------------------------------
    // MARK: - SEND CERTIFICATED SMS
    //-------------------------------------
    @IBAction func sendCertificatedSMS(_ sender: UIButton) {
        self.doneText()
        guard let phone = self.phoneTextField.text, phone != "", self.bodyTextView.text != "", let source = self.sourceTextField.text, source != "" else {
            self.present(Common().showAlert(title: "Error", message: "Phone, message and sender are compulsory"), animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Acknowledgment of receipt", message: "Write your email to receive the shipping report", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        })
        let confirmAction = UIAlertAction(title: "Send", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let txt = alert.textFields?.first?.text, txt != "" {
                sms_sendCertificatedSMS(destination: "\(phone)", body: self.bodyTextView.text, source: source, receipt: txt, date: self.dateSelected) { (result) in
                    switch result {
                    case .successWithData(let data):
                        if let json = data as? [String:Any] {
                            self.jsonTreatment(json: json)
                        }
                        
                    case .error(let error):
                        self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                        
                    }
                }
            }
        })
        alert.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            print("Canelled")
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //-------------------------------------
    // MARK: - CALCULATE COST PER SMS
    //-------------------------------------
    @IBAction func calculateCostPerSMS(_ sender: UIButton) {
        self.doneText()
        guard self.bodyTextView.text != "" else {
            self.present(Common().showAlert(title: "Error", message: "Message is compulsory"), animated: true, completion: nil)
            return
        }
        
        sms_calculateCostPerSMS(body: self.bodyTextView.text, unicode: nil, type: nil) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any], let cost = json["credits"] as? Int {
                    print(json)
                    self.present(Common().showAlert(title: "Cost per SMS", message: "Credits: \(cost)"), animated: true, completion: nil)
                } else {
                    self.present(Common().showAlert(title: "Error", message: "An error occurred, please review the data and try again"), animated: true, completion: nil)
                }
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
        }
    }
    
    //-------------------------------------
    // MARK: - HELPER
    //-------------------------------------
    private func jsonTreatment(json: [String:Any]) {
        print(json)
        if let _ = json["id"] as? String {
            self.present(Common().showAlert(title: "SMS sent", message: "Your SMS has been sent successfully"), animated: true, completion: nil)
            self.clearData()
        } else {
            self.present(Common().showAlert(title: "Error", message: "An error occurred, please review the data and try again"), animated: true, completion: nil)
        }
    }
    
    private func clearData() {
        self.phoneTextField.text = ""
        self.bodyTextView.text = ""
        self.dateSelected = nil
        self.dateSelectedLabel.text = ""
    }
    
}
