//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject
{
    // As an example adding security methods
    static let policy = ServerTrustPolicy.pinCertificates(certificates: ServerTrustPolicy.certificates(), validateCertificateChain: true, validateHost: true)
    static let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "https://api.openweathermap.org": .disableEvaluation // for Development TEST API removing SSL certificate
    ]
    static let manager:AuthorizationManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        return AuthorizationManager(configuration: configuration,serverTrustPolicyManager:ServerTrustPolicyManager(policies:serverTrustPolicies))
    }()
}

extension Foundation.URLRequest {
    static func allowsAnyHTTPSCertificateForHost(_ host: String) -> Bool {
        return true
    }
}
