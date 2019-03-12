//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [WeatherDetails]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let id: Int
    let name: String
}
