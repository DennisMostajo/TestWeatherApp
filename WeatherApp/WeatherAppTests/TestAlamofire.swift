//
//  TestAlamofire.swift
//  WeatherAppTests
//
//  Created by Dennis Mostajo on 3/12/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import XCTest
import Alamofire
@testable import WeatherApp

class TestAlamofire: XCTestCase {

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
            func testExample() {
                let e = expectation(description: "Alamofire")
                let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=35.689499&lon=139.691711&appid=0cd6ff32290332146d03b1164967da64&units=metric"
                Alamofire.request(urlString)
                    .response { response in
                        XCTAssertNil(response.error, "Whoops, error \(response.error!.localizedDescription)")
                        XCTAssertNotNil(response, "No response")
                        XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
                        e.fulfill()
                }
                waitForExpectations(timeout: 5.0, handler: nil)
            }
        }
    }

}
