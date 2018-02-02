//
//  MensamaticSMS.swift
//  MensamaticSMS
//
//  Created by Juantri on 9/1/18.
//

import Foundation

//--------------------------------------------------------
// MARK: Results
//--------------------------------------------------------

public enum SMSNetworkProviderResult {
    case successWithData(Any?)
    case error(SMSNetworkError) //codigo y descripción error 
}

public enum SMSNetworkError: Error, LocalizedError, CustomStringConvertible {
    case generic
    case errorFromAPI([String:Any])
    case parsing(String)
    case noMandatoryParameter(String)
    case unAuthorized
    
    var localizedDescription: String{
        switch self {
        case .unAuthorized:
            return NSLocalizedString("No tiene autorización.", comment: "No tiene autorización.")
        case .parsing(let object):
            return NSLocalizedString("No se pudo transformar ", comment: "No se pudo transformar.") + "\(object)"
        case .noMandatoryParameter(let object):
            return NSLocalizedString("No se incluyó el parámetro obligatorio ", comment: "") + "\(object)"
        case .errorFromAPI(let json):
            if let message = json["message"] as? String {
                return message
            }
            return NSLocalizedString("Ocurrió un error.", comment:"")
        default:
            return NSLocalizedString("Ocurrió un error.", comment:"")
        }
    }
    public var errorDescription: String?{
        return self.localizedDescription
    }
    public var description: String{
        return self.localizedDescription
    }
    
    
}

private func SMSResponseTreatment(data: Data?, response: URLResponse?, error: Error?) -> SMSNetworkProviderResult {
    
    if error != nil {
        return .error(SMSNetworkError.generic)
    }
    
    guard let data = data else {
        return .error(SMSNetworkError.generic)
    }
    
    do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            return .error(SMSNetworkError.parsing(String.init(data: data, encoding: .utf8) ?? "Error"))
        }
        
        return .successWithData( json )
        
    } catch let error {
        print(error)
        return .error(SMSNetworkError.generic)
    }
    
}

//--------------------------------------------------------
// MARK: Parameters encoding
//--------------------------------------------------------

private func sms_encodeParameters(dict:[String:Any]) -> String? {
    do{
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        return jsonString;
    }
    catch{
        print(error)
    }
    return nil
}

//--------------------------------------------------------
// MARK: Headers
//--------------------------------------------------------

private var userToken: String?

private func SMS_headers() -> Dictionary<String,String> {
    var headers = ["Content-Type":"application/json"]
    
    if let token = userToken {
        headers["Authorization"] = "Token \(token)"
        return headers
    }
    return headers
}

private func SMS_headers2() -> Dictionary<String,String> {
    var headers = ["Content-Type":"application/json"]
    
    if let token = userToken {
        headers["Authorization"] = token
        return headers
    }
    return headers
}


//--------------------------------------------------------
// MARK: Authentication
//--------------------------------------------------------

/// Gets a Token to grant access to the API.
///
/// - Parameters:
///   - user: user name
///   - password: user password
///   - completion: method returns success or error with the error information
public func sms_authentication(user: String, password: String, completion: @escaping(SMSNetworkProviderResult)->()) {

    guard let url : URL = URL(string: APIEndpointUrl.signIn.SMS_endpointUrl() ) else { return }

    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let dic = ["username": user, "password" : password]
    
    guard let body = sms_encodeParameters(dict: dic) else {
        completion(SMSNetworkProviderResult.error(SMSNetworkError.parsing(dic.debugDescription)))
        return
    }
    
    request.httpBody = body.data(using: .utf8)
    request.allHTTPHeaderFields = SMS_headers()
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if error != nil {
            print(error ?? "Error")
            completion(.error(.generic))
            return
        }
        
        guard let data = data else {
            print("Error parsing data")
            DispatchQueue.main.async {
                completion(.error(.generic))
            }
            return
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                DispatchQueue.main.async {
                    completion(.error(SMSNetworkError.generic))
                }
                return
            }
            
            if let message = json["message"] as? String {
                DispatchQueue.main.async {
                    completion(.error(SMSNetworkError.errorFromAPI(["message" : message])))
                }
                return
            }
            
            guard let token = json["token"] as? String else {
                DispatchQueue.main.async {
                    completion(.error(SMSNetworkError.generic))
                }
                return
            }
            userToken = token
            print(token)
            DispatchQueue.main.async {
                completion(.successWithData(""))
            }
            
            
        } catch let error {
            print(error)
            DispatchQueue.main.async {
                completion(.error(SMSNetworkError.generic))
            }
        }
        
        }.resume()
    
}

//--------------------------------------------------------
// MARK: API SMS
//--------------------------------------------------------
public func sms_sendSMS(destination: String, body: String, source: String, date: Date?, completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.sendSMS.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = SMS_headers()
    
    var dic = ["destination" : destination, "body" : body, "source" : source]
    
    if let date = date {
        dic["scheduled_datetime"] = date.sms_dateToBackendFormat()
    }
    
    guard let body = sms_encodeParameters(dict: dic) else {
        DispatchQueue.main.async {
            completion(SMSNetworkProviderResult.error(SMSNetworkError.parsing(dic.debugDescription)))
        }
        return
    }
    
    request.httpBody = body.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}

public func sms_sendUnicodeSMS(destination: String, body: String, source: String, date: Date?, completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.sendUnicodeSMS.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = SMS_headers()
    
    var dic = ["destination" : destination, "body" : body, "source" : source]
    
    if let date = date {
        dic["scheduled_datetime"] = date.sms_dateToBackendFormat()
    }
    
    guard let body = sms_encodeParameters(dict: dic) else {
        DispatchQueue.main.async {
            completion(SMSNetworkProviderResult.error(SMSNetworkError.parsing(dic.debugDescription)))
        }
        return
    }
    
    request.httpBody = body.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}

public func sms_sendCertificatedSMS(destination: String, body: String, source: String, typeSMS: Int?, receipt: String?, date: Date?, completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.sendCertificatedSMS.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = SMS_headers()
    
    var dic: [String:Any] = ["destination" : destination, "body" : body, "source" : source]
    
    if let typeSMS = typeSMS {
        dic["type_sms"] = "\(typeSMS)"
    } else {
        dic["type_sms"] = 0
    }
    
    if let receipt = receipt {
        dic["receipt"] = receipt
    }
    
    if let date = date {
        dic["scheduled_datetime"] = date.sms_dateToBackendFormat()
    }
    
    guard let body = sms_encodeParameters(dict: dic) else {
        DispatchQueue.main.async {
            completion(SMSNetworkProviderResult.error(SMSNetworkError.parsing(dic.debugDescription)))
        }
        return
    }
    
    request.httpBody = body.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}

public func sms_listSentSMS(id: String?, destination: String?, source: String?, from_date: String?, to_date: String?, date: Date?, sent: Bool?, sent_status: String?, completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.listSentSMS.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = SMS_headers()
    
//    var dic = ["destination" : destination, "body" : body, "source" : source]
//
//    if let typeSMS = typeSMS {
//        dic["type_sms"] = "\(typeSMS)"
//    }
//
//    if let receipt = receipt {
//        dic["receipt"] = receipt
//    }
//
//    if let date = date {
//        dic["scheduled_datetime"] = date.sms_dateToBackendFormat()
//    }
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}

public func sms_listIncomingSMS(completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.listIncomingSMS.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = SMS_headers()
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}

public func sms_send2WaySMS(destination: String, body: String, source: String, unicode: Bool?, date: Date?, completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.send2waySMS.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = SMS_headers()
    
    var dic: [String:Any] = ["destination" : destination, "body" : body, "source" : source, "unicode" : false]
    
    if let unicode = unicode {
        dic["unicode"] = unicode
    }
    
    if let date = date {
        dic["scheduled_datetime"] = date.sms_dateToBackendFormat()
    }
    
    guard let body = sms_encodeParameters(dict: dic) else {
        DispatchQueue.main.async {
            completion(SMSNetworkProviderResult.error(SMSNetworkError.parsing(dic.debugDescription)))
        }
        return
    }
    
    request.httpBody = body.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}

public func sms_calculateCostPerSMS(body: String, unicode: Bool?, type: Int?, completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.calculateCostPerSMS.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = SMS_headers()
    
    var dic: [String:Any] = ["body" : body, "unicode" : false]
    
    if let unicode = unicode {
        dic["unicode"] = unicode
    }
    
    if let type = type {
        dic["type_sms"] = type
    }
    
    guard let body = sms_encodeParameters(dict: dic) else {
        DispatchQueue.main.async {
            completion(SMSNetworkProviderResult.error(SMSNetworkError.parsing(dic.debugDescription)))
        }
        return
    }
    
    request.httpBody = body.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}

public func sms_cancelScheduledSMS(id: String, completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.cancelScheduleSMS.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = SMS_headers()
    
    let dic: [String:Any] = ["id" : id]
    
    guard let body = sms_encodeParameters(dict: dic) else {
        DispatchQueue.main.async {
            completion(SMSNetworkProviderResult.error(SMSNetworkError.parsing(dic.debugDescription)))
        }
        return
    }
    
    request.httpBody = body.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}

public func sms_currentUserCredits(completion: @escaping(SMSNetworkProviderResult)->()) {
    
    guard let url = URL(string: APIEndpointUrl.currentUserCredits.SMS_endpointUrl() ) else { return }
    
    var request : URLRequest = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = SMS_headers()
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        DispatchQueue.main.async {
            completion(SMSResponseTreatment(data: data, response: response, error: error))
        }
        }.resume()
    
}
