//
//  Constants.swift
//  MensamaticSMS
//
//  Created by Juantri on 9/1/18.
//

import Foundation

//--------------------------------------------------------
// MARK: Constants
//--------------------------------------------------------
let kProduction: Bool = false
private let kAPIURL = kProduction ? "https://api.mensamatic.com/" : "http://api.develapps.es/"
private let kAPIVersion = "v1/"

//--------------------------------------------------------
// MARK: Endpoints
//--------------------------------------------------------
public enum APIEndpointUrl {
    case signIn
    case sendSMS
    case sendUnicodeSMS
    case sendCertificatedSMS
    case listSentSMS
    case listIncomingSMS
    case send2waySMS
    case calculateCostPerSMS
    case cancelScheduleSMS
    case currentUserCredits
    
    func SMS_endpointUrl() -> String {
        
        switch self {
        case .signIn:
            return kAPIURL+kAPIVersion+"sign_in/"
            
        case .sendSMS:
            return kAPIURL+kAPIVersion+"sms/send/"
            
        case .sendUnicodeSMS:
            return kAPIURL+kAPIVersion+"sms/send_unicode/"
            
        case .sendCertificatedSMS:
            return kAPIURL+kAPIVersion+"sms/send_certificated/"
            
        case .listSentSMS:
            return kAPIURL+kAPIVersion+"sms/"
            
        case .listIncomingSMS:
            return kAPIURL+kAPIVersion+"sms/incoming_sms/"
            
        case .send2waySMS:
            return kAPIURL+kAPIVersion+"sms/2waysms/"
            
        case .calculateCostPerSMS:
            return kAPIURL+kAPIVersion+"sms/cost/"
            
        case .cancelScheduleSMS:
            return kAPIURL+kAPIVersion+"sms/cancel/"
            
        case .currentUserCredits:
            return kAPIURL+kAPIVersion+"sms/credits/"
            
        }
        
    }
}

//--------------------------------------------------------
// MARK: Constants
//--------------------------------------------------------
public enum SMSType: Int {
    case simple = 0
    case cetificate = 1
    case contract = 2
}

public enum SentStatus: Int {
    case unknown = 0
    case received = 1
    case failed = 2
    case canceled = 3
}
