//
//  ListSMSCell.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 5/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MensamaticSMS

class ListSMSCell: UITableViewCell {
    
    var unknownColor: UIColor = UIColor(red: 135.0/255.0, green: 218.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    var receivedColor: UIColor = UIColor(red: 15.0/255.0, green: 160.0/255.0, blue: 37.0/255.0, alpha: 1.0)
    var failledColor: UIColor = UIColor(red: 255.0/255.0, green: 165.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    var canceledColor: UIColor = UIColor(red: 219.0/255.0, green: 30.0/255.0, blue: 82.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var smsStateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate : CancelScheduledSMSProtocol?
    
    var smsID: String?
    var smsStatus: Int = 0
    
    func configureForCell(_ cellInfo: [String:Any]){
        if let destination = cellInfo["destination"] as? String {
            self.destinationLabel.text = destination
        }
        
        if let date = cellInfo["created"] as? String {
            self.dateLabel.text = date.dateStringToDate().dateFormat()
        }
        
        if let body = cellInfo["body"] as? String {
            self.messageLabel.text = body
        }
        
        if let source = cellInfo["source"] as? String {
            self.senderLabel.text = "Source: " + source
        }
        
        if let smsStatus = cellInfo["sent_status"] as? Int {
            var status: String = "Sent"
            var color = self.unknownColor
            if smsStatus == sms_kSentStatus.received.rawValue {
                status = "Received"
                color = self.receivedColor
            } else if smsStatus == sms_kSentStatus.failed.rawValue {
                status = "Failed"
                color = self.failledColor
            } else if smsStatus == sms_kSentStatus.canceled.rawValue {
                status = "Cancelled"
                color = self.canceledColor
            }
            self.smsStateLabel.text = status
            self.smsStateLabel.textColor = color
            self.smsStatus = smsStatus
        }
        
        if let _ = cellInfo["scheduled_datetime"] as? NSNull {
            self.cancelButton.isHidden = true
        } else {
            guard let id = cellInfo["id"] as? String else { return }
            self.cancelButton.isHidden = false
            self.smsID = id
            if self.smsStatus != 0 {
                self.cancelButton.isHidden = true
            }
        }
        
    }
    
    @IBAction func cancelScheduledSMS(_ sender: UIButton) {
        guard let smsID = self.smsID else { return }
        self.delegate?.cancelScheduledSMS(smsID)
    }
    
}
