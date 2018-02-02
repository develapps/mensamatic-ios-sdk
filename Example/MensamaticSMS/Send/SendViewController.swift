//
//  SendViewController.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 2/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

class SendViewController: UIViewController, UITextViewDelegate {

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
        
        self.bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.bodyTextView.layer.borderWidth = 1.0
        self.bodyTextView.layer.cornerRadius = 2
        self.bodyTextView.clipsToBounds = true
        
        self.bodyTextView.delegate = self
        
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
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy hh:mm"
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
        guard let phone = self.phoneTextField.text, self.bodyTextView.text != "", let source = self.sourceTextField.text else { return }
        
        sms_sendSMS(destination: "+34\(phone)", body: self.bodyTextView.text, source: source, date: self.dateSelected) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                    self.phoneTextField.text = ""
                    self.bodyTextView.text = ""
                    self.dateSelected = nil
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
        guard let phone = self.phoneTextField.text, self.bodyTextView.text != "", let source = self.sourceTextField.text else { return }
        
        sms_sendUnicodeSMS(destination: "+34\(phone)", body: self.bodyTextView.text, source: source, date: self.dateSelected) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                    self.phoneTextField.text = ""
                    self.bodyTextView.text = ""
                    self.dateSelected = nil
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
        guard let phone = self.phoneTextField.text, self.bodyTextView.text != "", let source = self.sourceTextField.text else { return }
        
        sms_sendCertificatedSMS(destination: "+34\(phone)", body: self.bodyTextView.text, source: source, typeSMS: nil, receipt: nil, date: self.dateSelected) { (result) in
            switch result {
            case .successWithData(let data):
                if let json = data as? [String:Any] {
                    print(json)
                    self.phoneTextField.text = ""
                    self.bodyTextView.text = ""
                    self.dateSelected = nil
                }
                
            case .error(let error):
                self.present(Common().showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                
            }
        }
    }
    
}
