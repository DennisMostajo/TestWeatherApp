//
//  StorageHelper.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import UIKit

class StorageHelper
{
    class func setIsFirstTime(_ isFirstTime: Bool)
    {
        UserDefaults.standard.set(isFirstTime, forKey: StorageProperty.isFirstTime.rawValue)
    }
    
    class func isFirstTime() -> Bool
    {
        return !UserDefaults.standard.bool(forKey: StorageProperty.isFirstTime.rawValue)
    }
    
    class func clearAll ()
    {
        for key in StorageProperty.allValues
        {
            switch (key)
            {
            default:
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
    }
}

enum StorageProperty:String
{
    case isFirstTime = "isFirstTime"
    
    static let allValues:[StorageProperty] = [isFirstTime]
}
