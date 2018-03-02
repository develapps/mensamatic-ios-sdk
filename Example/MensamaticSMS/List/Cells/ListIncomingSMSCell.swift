//
//  ListIncomingSMSCell.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 5/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

class ListIncomingSMSCell: UITableViewCell {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureForCell(_ cellInfo: [String:Any]){
        if let destination = cellInfo["destination"] as? String {
            self.destinationLabel.text = destination
        }
        
        if let date = cellInfo["created"] as? String {
            self.dateLabel.text = date.dateStringToDate().dateFormat()
        }
        
        if let body = cellInfo["text"] as? String {
            self.messageLabel.text = body
        }
        
        if let source = cellInfo["source"] as? String {
            self.senderLabel.text = source
        }
        
    }
    
}
