//
//  OpenWeatherMapAPI.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

let API_KEY = "0cd6ff32290332146d03b1164967da64"
let SERVER_URL = "https://api.openweathermap.org/data/2.5?"
let WEATHER = "weather"
var units = "metric"
import UIKit
import Alamofire
import SwiftyJSON

enum OpenWeatherMapAPI: URLRequestConvertible
{
    static let baseURLString = SERVER_URL
    
    case getWeatherCity(latitude:Double, longitude: Double)
    
    var method: Alamofire.HTTPMethod
    {
        switch self
        {
        default:
            return .get
        }
    }
    
    var path:String
    {
        switch self
        {
        case .getWeatherCity:
            return "\(WEATHER)"
        }
    }
    
    func asURLRequest() throws -> URLRequest
    {
        let URL = Foundation.URL(string: OpenWeatherMapAPI.baseURLString)!
        var request = URLRequest(url:URL.appendingPathComponent(path))
        debugPrint("URL request:\(URL.appendingPathComponent(path))")
        request.httpMethod = method.rawValue
        
        var parameters:[String:AnyObject] = [:]
        
        switch self
        {
        case .getWeatherCity(let lat, let lon):
            parameters["lat"] = lat as AnyObject
            parameters["lon"] = lon as AnyObject
            parameters["appid"] = API_KEY as AnyObject
            parameters["units"] = units as AnyObject
            break
        }
        debugPrint(parameters)
        let encoding = URLEncoding.methodDependent
        return try! encoding.encode(request, with: parameters)
    }
}

