//
//  Common.swift
//  MensamaticSMS_Example
//
//  Created by Juantri on 2/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class Common {
    
    func showAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "Accept", style: .default) { (action) in
            
        }
        alert.addAction(acceptButton)
        
        return alert
    }
    
}

extension String {
    
    func dateStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return Date()
    }
    
}

extension Date {
    
    func dateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: self)
        
        return dateString
    }
    
}
