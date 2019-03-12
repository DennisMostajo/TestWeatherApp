//
//  TestPerformanceRequest.swift
//  WeatherAppTests
//
//  Created by Dennis Mostajo on 3/12/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import WeatherApp

class TestPerformanceRequest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            _ = NetworkManager.manager.startRequest(OpenWeatherMapAPI.getWeatherCity(latitude: 35.689499, longitude: 139.691711),
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

}
