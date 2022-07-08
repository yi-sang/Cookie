//
//  HTTPUtils.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import Alamofire
import UIKit

struct HTTPUtils {
    
    static let url = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String ?? ""
    
    static let defaultSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 4
        
        return Session(configuration: configuration, eventMonitors: [MyLogger()])
    }()
    
    static let fileUploadSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        
        return Session(configuration: configuration, eventMonitors: [MyLogger()])
    }()
    
    static func jsonHeader() -> HTTPHeaders {
        let headers = ["Accept": "application/json"] as HTTPHeaders
        
        return headers
    }
}
