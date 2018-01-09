//
//  MensamaticSMS.swift
//  MensamaticSMS
//
//  Created by Juantri on 9/1/18.
//

import Foundation

//public class SMSMensamaticSMS {

    public func sms_obtainConstantValueFor(smsType: Int) -> String {
        switch smsType {
        case 0:
            return "simple"
        case 1:
            return "cetificate"
        case 2:
            return "contract"
        default:
            return "simple"
        }
    }
    
//}

