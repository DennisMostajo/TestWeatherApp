//
//  AuthorizationManager.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

open class AuthorizationManager: SessionManager {
    
    public typealias NetworkSuccessHandler = (HTTPURLResponse?,AnyObject?) -> Void
    public typealias NetworkFailureHandler = (HTTPURLResponse?, AnyObject?, Error) -> Void
    
    fileprivate typealias CachedTask = () -> Void
    
    fileprivate var cachedTasks = Array<CachedTask>()
    fileprivate var isRefreshing = false {
        didSet {
            if !isRefreshing {
                self.cachedTasks = self.cachedTasks.compactMap{ element in
                    element()
                    return nil
                }
            }
        }
    }
    
    open func startRequest(
        _ urlRequestConvertible: URLRequestConvertible,
        success: NetworkSuccessHandler?,
        failure: NetworkFailureHandler?) -> Request?
    {
        let cachedTask: CachedTask = { [weak self] in
            guard let strongSelf = self else { return }
            
            _ = strongSelf.startRequest(
                urlRequestConvertible,
                success: success,
                failure: failure
            )
        }
        
        if self.isRefreshing {
            self.cachedTasks.append(cachedTask)
            return nil
        }
        
        //TODO: Append your auth tokens here to your parameters
        
        let request = self.request(urlRequestConvertible)
        request.response { [weak self] response in
            guard let strongSelf = self else { return }
            // check if is unauthorized
            // as standard example status code 401
            let data = response.data
            if let response = response.response , response.statusCode == 401
            {
                let json = try! JSON(data: data!)
                let message = json["msg"].stringValue
                // check is is token has expired
                if (message == "Token has expired")
                {
                    debugPrint("Authorization Manager response:\(json)")
                    strongSelf.cachedTasks.append(cachedTask)
                    strongSelf.refreshTokens()
                }
                return
            }
            
            if let error = response.error {
                failure?(response.response, response.data as AnyObject?, error)
            } else {
                success?(response.response, response.data as AnyObject)
            }
        }
        request.resume()
        
        return request
    }
    
    func refreshTokens()
    {
        //TODO: Implement here the refresh tokens for best practices
    }
}
