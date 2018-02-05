//
//  FilterListViewController.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 5/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

struct Filter {
    var destination: String?
    var sender: String?
    var fromDate: Date?
    var toDate: Date?
    var sent: Bool?
    var sentStatus: Int?
}

protocol FilterListDataProtocol {
    func filterListDataWith( _ filter: Filter)
}

class FilterListViewController: UIViewController {

    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var sentSwitch: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let fromDatePicker = UIDatePicker()
    var fromDateSelected: Date?
    let toDatePicker = UIDatePicker()
    var toDateSelected: Date?
    
    var delegate: FilterListDataProtocol?
    
    var filter: Filter?
    var dontSaveFilter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Filter"
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneText))
        toolbar.setItems([doneButton], animated: false)
        
        self.destinationTextField.inputAccessoryView = toolbar
        self.senderTextField.inputAccessoryView = toolbar
        
        self.fromDateLabel.text = ""
        self.toDateLabel.text = ""
        
        self.fromDatePicker.datePickerMode = .dateAndTime
        self.fromDatePicker.maximumDate = Date()
        self.toDatePicker.datePickerMode = .dateAndTime
        self.toDatePicker.minimumDate = Date()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if !self.dontSaveFilter {
            self.filter = Filter()
            self.filter?.destination = self.destinationTextField.text
            self.filter?.sender = self.senderTextField.text
            self.filter?.fromDate = self.fromDateSelected
            self.filter?.toDate = self.toDateSelected
            self.filter?.sent = self.sentSwitch.isOn
            self.filter?.sentStatus = self.segmentedControl.selectedSegmentIndex
            self.delegate?.filterListDataWith(self.filter!)
        }
        
        super.viewWillDisappear(animated)
    }
    
    //-------------------------------------
    // MARK: - Actions
    //-------------------------------------
    @IBAction func openFromDatePicker(_ sender: UIButton) {
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFromDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(cancelFromDatePicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        self.fromDateTextField.inputAccessoryView = toolbar
        self.fromDateTextField.inputView = self.fromDatePicker
        self.fromDateTextField.becomeFirstResponder()
    }
    
    @objc func doneFromDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.fromDateLabel.text = formatter.string(from: self.fromDatePicker.date)
        self.fromDateSelected = self.fromDatePicker.date
        self.fromDateTextField.resignFirstResponder()
    }
    
    @objc func cancelFromDatePicker(){
        self.fromDateLabel.text = ""
        self.fromDateSelected = nil
        self.fromDateTextField.resignFirstResponder()
    }
    
    @IBAction func openToDatePicker(_ sender: UIButton) {
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneToDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(cancelToDatePicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        self.toDateTextField.inputAccessoryView = toolbar
        self.toDateTextField.inputView = self.toDatePicker
        self.toDateTextField.becomeFirstResponder()
    }
    
    @objc func doneToDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.toDateLabel.text = formatter.string(from: self.toDatePicker.date)
        self.toDateSelected = self.toDatePicker.date
        self.toDateTextField.resignFirstResponder()
    }
    
    @objc func cancelToDatePicker(){
        self.toDateLabel.text = ""
        self.toDateSelected = nil
        self.toDateTextField.resignFirstResponder()
    }
    
    @objc func doneText(){
        self.destinationTextField.resignFirstResponder()
        self.senderTextField.resignFirstResponder()
        self.fromDateTextField.resignFirstResponder()
        self.toDateTextField.resignFirstResponder()
    }
    
    @IBAction func changedSwitch(_ sender: UISwitch) {
        
    }
    
    @IBAction func sentStatusSegmentedChanged(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func restartListWithoutFilters(_ sender: UIBarButtonItem) {
        self.dontSaveFilter = true
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
