//
//  TestOpenWeatherMapAPI.swift
//  WeatherAppTests
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import WeatherApp

class TestOpenWeatherMapAPI: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetWeatherFromCoord()
    {
        _ = NetworkManager.manager.startRequest(OpenWeatherMapAPI.getWeatherCity(latitude: -666.999, longitude: 999.666),
        success:
        {
            responseRequest,responseData in
            debugPrint("Test getWeatherCity StatusCode:\(String(describing: responseRequest?.statusCode))")
            let json = try! JSON(data: responseData! as! Data)
            debugPrint("Test getWeatherCity:\(json)")
        },
        failure:
        {
            _, _, error in
            debugPrint("error:\(error)")
        })
    }
}
