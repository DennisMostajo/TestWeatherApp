//
//  TestWeatherItemCalculation.swift
//  WeatherAppTests
//
//  Created by Dennis Mostajo on 3/12/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import XCTest
@testable import WeatherApp

class TestWeatherItemCalculation: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetLondonWeatherFromCoordUsingCodable()
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
                    // Test convert to Fahrenheit
                    XCTAssertEqual(weatherCodable.main.temp, (weatherCodable.main.temp! * (9/5))+32)
                    XCTAssertEqual(weatherCodable.main.tempMax, (weatherCodable.main.tempMax! * (9/5))+32)
                    XCTAssertEqual(weatherCodable.main.tempMin, (weatherCodable.main.tempMin! * (9/5))+32)
                    // Test convert to Kelvin
                    XCTAssertEqual(weatherCodable.main.temp, (weatherCodable.main.temp! + 273.15))
                    XCTAssertEqual(weatherCodable.main.tempMax, (weatherCodable.main.tempMax! + 273.15))
                    XCTAssertEqual(weatherCodable.main.tempMin, (weatherCodable.main.tempMin! + 273.15))
                    
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
