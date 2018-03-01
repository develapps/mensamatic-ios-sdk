//
//  FilterTextFieldCell.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 1/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

enum FilterTextFieldCellType {
    case text
    case date
}

protocol FilterTextFieldCellProtocol: NSObjectProtocol {
    func textChanged(typeOfCell: FilterTextFieldCellType, text: String?, field: Int, date: Date?)
}

class FilterTextFieldCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var secondTextField: UITextField!
    
    let fromDatePicker = UIDatePicker()
    let toDatePicker = UIDatePicker()
    
    var delegate: FilterTextFieldCellProtocol?
    
    var typeOfCell: FilterTextFieldCellType = .text
    
    //-------------------------------------
    // MARK: - Setup Cell
    //-------------------------------------
    func setupCell(type: FilterTextFieldCellType) {
        self.typeOfCell = type
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneText))
        toolbar.setItems([doneButton], animated: false)
        
        self.firstTextField.inputAccessoryView = toolbar
        self.secondTextField.inputAccessoryView = toolbar
        
        if type == .text {
            self.firstTitleLabel.text = "Destination"
            self.secondTitleLabel.text = "Source"
            
            self.firstTextField.delegate = self
            self.secondTextField.delegate = self
        } else {
            self.firstTitleLabel.text = "From date"
            self.secondTitleLabel.text = "To date"
            
            self.fromDatePicker.datePickerMode = .dateAndTime
            self.toDatePicker.datePickerMode = .dateAndTime
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFromDatePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(cancelFromDatePicker))
            
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            
            self.firstTextField.inputAccessoryView = toolbar
            self.firstTextField.inputView = self.fromDatePicker
            
            let toolbar2 = UIToolbar()
            toolbar2.sizeToFit()
            let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneToDatePicker))
            let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton2 = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(cancelToDatePicker))
            
            toolbar2.setItems([cancelButton2,spaceButton2,doneButton2], animated: false)
            
            self.secondTextField.inputAccessoryView = toolbar2
            self.secondTextField.inputView = self.toDatePicker
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            self.delegate?.textChanged(typeOfCell: self.typeOfCell, text: text, field: textField.tag, date: nil)
        }
    }
    
    //-------------------------------------
    // MARK: - Actions
    //-------------------------------------
    @objc func doneFromDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.firstTextField.text = formatter.string(from: self.fromDatePicker.date)
        self.firstTextField.resignFirstResponder()
        self.delegate?.textChanged(typeOfCell: self.typeOfCell, text: nil, field: 0, date: self.fromDatePicker.date)
    }
    
    @objc func cancelFromDatePicker(){
        self.firstTextField.text = ""
        self.firstTextField.resignFirstResponder()
        self.delegate?.textChanged(typeOfCell: self.typeOfCell, text: nil, field: 0, date: nil)
    }
    
    @objc func doneToDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.secondTextField.text = formatter.string(from: self.toDatePicker.date)
        self.secondTextField.resignFirstResponder()
        self.delegate?.textChanged(typeOfCell: self.typeOfCell, text: nil, field: 1, date: self.toDatePicker.date)
    }
    
    @objc func cancelToDatePicker(){
        self.secondTextField.text = ""
        self.secondTextField.resignFirstResponder()
        self.delegate?.textChanged(typeOfCell: self.typeOfCell, text: nil, field: 1, date: nil)
    }
    
    @objc func doneText(){
        self.firstTextField.resignFirstResponder()
        self.secondTextField.resignFirstResponder()
    }
    
}
