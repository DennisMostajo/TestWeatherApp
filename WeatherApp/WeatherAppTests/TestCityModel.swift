//
//  TestCityModel.swift
//  WeatherAppTests
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import XCTest
@testable import WeatherApp

class TestCityModel: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitCityModel()
    {
        let city = CityModel()
        city.id = 401
        city.name = "Avantica Land"
        city.country = "GP"
        city.latitude = -666.999
        city.longitude = 999.666
        city.temp_celsius = 0.0
        city.temp_fahrenheit = (city.temp_celsius * (9/5))+32
        debugPrint("testInitCityModel: \(city.name) - \(city.country)")
        XCTAssertNotNil(city)
    }
}
