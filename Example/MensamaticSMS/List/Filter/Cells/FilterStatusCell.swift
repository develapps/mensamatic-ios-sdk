//
//  FilterStatusCell.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 1/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol FilterStatusCellProtocol: NSObjectProtocol {
    func switchChanged(isActive: Bool, sentStatus: Int)
}

class FilterStatusCell: UITableViewCell {
    
    @IBOutlet var allSwitchs: [UISwitch]!
    
    var delegate: FilterStatusCellProtocol?
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        
        for aSwitch in self.allSwitchs {
            if aSwitch.tag != sender.tag {
                aSwitch.isOn = false
            }
        }
        
        self.delegate?.switchChanged(isActive: sender.isOn, sentStatus: sender.tag)
    }
    
    
}
