//
//  TestCodable.swift
//  WeatherAppTests
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import XCTest
@testable import WeatherApp

class TestCodable: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetWeatherFromCoordUsingCodable()
    {
        _ = NetworkManager.manager.startRequest(OpenWeatherMapAPI.getWeatherCity(latitude: 51.50853, longitude: -0.12574),
                                                success:
            {
                responseRequest,responseData in
                debugPrint("Test getWeatherCity StatusCode:\(String(describing: responseRequest?.statusCode))")
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let weatherCodable = try decoder.decode(CurrentWeather.self, from: responseData as! Data)
                    debugPrint("--->\(weatherCodable.name): \(String(describing: weatherCodable.main.temp))")
                   
                } catch let error {
                    debugPrint("Error creating current weather from JSON because: \(error.localizedDescription)")
                }
        },
                                                failure:
            {
                _, _, error in
                debugPrint("error:\(error)")
        })
    }
}
