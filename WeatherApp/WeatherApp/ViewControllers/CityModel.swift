//
//  CityModel.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

@objc class CityModel: Object
{
    /**
     * City Model
     *
     * - parameters:
     *      -id: unique identifier of the taxi model object
     *      -name: name of the city string value
     *      -country: country code string value
     *      -latutude: latitude double value
     *      -longitude: longitude double value
     *      -temp_celsius: celsius temperature double value
     *      -temp_fahrenheit: fahrenheit temperature double value
     */
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var temp_celsius = 0.0
    @objc dynamic var temp_fahrenheit = 0.0
    
    override static func primaryKey() -> String
    {
        return "id"
    }
    
    /**
     This method parse the City information from JSON and return a Realm cityModel Object.
     */
    static func fromJson(_ json:JSON) -> CityModel
    {
        let city = CityModel()
        city.id = json["id"].intValue
        city.name = json["name"].stringValue
        city.country = json["country"].stringValue
        city.latitude = json["coord"]["lat"].doubleValue
        city.longitude = json["coord"]["lon"].doubleValue
        city.temp_celsius = json["main"]["temp"].doubleValue
        city.temp_fahrenheit = (city.temp_celsius * (9/5))+32
        return city
    }
}

//(0°C × 9/5) + 32 = 32°F
