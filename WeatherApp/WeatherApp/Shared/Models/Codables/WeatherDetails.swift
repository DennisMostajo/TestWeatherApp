//
//  WeatherDetails.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

struct WeatherDetails: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
