//
//  Constants.swift
//  MensamaticSMS
//
//  Created by Juantri on 9/1/18.
//

import Foundation

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
