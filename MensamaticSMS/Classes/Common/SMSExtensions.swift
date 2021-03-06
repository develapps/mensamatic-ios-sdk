//
//  SMSExtensions.swift
//  MensamaticSMS
//
//  Created by Juantri on 9/1/18.
//

import Foundation

extension Date {
    
    func sms_dateToBackendFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormatter.string(from: self)
        
        return dateString
    }

}
