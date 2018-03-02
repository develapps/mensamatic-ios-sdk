//
//  FilterSelectorCell.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 1/3/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol FilterSentCellProtocol: NSObjectProtocol {
    func switchChanged(sent: Bool, sentSwitch: Int)
}

class FilterSentCell: UITableViewCell {
    
    @IBOutlet weak var sentSwitch: UISwitch!
    @IBOutlet weak var noSentSwitch: UISwitch!
    
    var delegate:FilterSentCellProtocol?
    
    @IBAction func chageSwitchStatus(_ sender: UISwitch) {
        if sender.tag == self.sentSwitch.tag {
            self.noSentSwitch.isOn = false
        } else {
            self.sentSwitch.isOn = false
        }
        self.delegate?.switchChanged(sent: sender.isOn, sentSwitch: sender.tag)
    }
    
}
