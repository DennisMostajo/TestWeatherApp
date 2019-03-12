//
//  Sys.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

struct Sys: Codable {
    let type: Int
    let id: Int
    let message: Double
    let country: String
    let sunrise: Int
    let sunset: Int
}
