//
//  DataBaseHelper.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import UIKit
import RealmSwift

class DataBaseHelper
{
    //-----------------------------------------------------------------------------------//
    //                                  TO MIGRATION
    //-----------------------------------------------------------------------------------//
    //-----------------------------------------------------------------------------------//
    // Change the value of DB_VERSION every time a change is made to the REALM database
    //-----------------------------------------------------------------------------------//
    static let DB_VERSION: UInt64 = 1
    //-----------------------------------------------------------------------------------//
    
    //MARK: Creates Methods
    
    class func setDefaultCities()
    {
        let cityUser = CityModel()
        cityUser.id = 1
        cityUser.name = "Default"
        cityUser.country = "DEFAULT"
        cityUser.latitude = 0.0
        cityUser.longitude = 0.0
        self.createOrUpdateCity(cityUser)
        let cityLondon = CityModel()
        cityLondon.id = 2
        cityLondon.name = "London"
        cityLondon.country = "GB"
        cityLondon.latitude = 51.50853
        cityLondon.longitude = -0.12574
        self.createOrUpdateCity(cityLondon)
        let cityNewYork = CityModel()
        cityNewYork.id = 3
        cityNewYork.name = "New York"
        cityNewYork.country = "US"
        cityNewYork.latitude = 43.000351
        cityNewYork.longitude = -75.499901
        self.createOrUpdateCity(cityNewYork)
        let cityTokyo = CityModel()
        cityTokyo.id = 4
        cityTokyo.name = "Tokyo"
        cityTokyo.country = "JP"
        cityTokyo.latitude = 35.689499
        cityTokyo.longitude = 139.691711
        self.createOrUpdateCity(cityTokyo)
    }
    
    class func createOrUpdateCity(_ city: CityModel)
    {
        do {
            let realm = try Realm()
            realm.refresh()
            try realm.write {
                realm.create(CityModel.self, value: city, update: true)
                debugPrint("--->city added or updated: \(city.name)")
            }
        } catch {
            debugPrint("Error creating or updating city")
        }
    }
    
    //MARK: Get Methods
    
    class func getCities() -> Results<CityModel>?
    {
        do {
            let realm = try Realm()
            return realm.objects(CityModel.self)
            //            return realm.objects(TaxiModel.self).sorted(byKeyPath: "id", ascending: true) // for sorted results
        } catch {
            return nil
        }
    }
    
    class func getUserCity() -> CityModel?
    {
        do
        {
            let realm = try Realm()
            return realm.object(ofType: CityModel.self, forPrimaryKey: 1)
        }
        catch
        {
            return nil
        }
    }
    
    //MARK: Update Methods
    
    class func updateCityUser(name:String, country:String,latitude:Double, longitude:Double)
    {
        if let userCity = self.getUserCity()
        {
            do
            {
                let realm = try Realm()
                realm.refresh()
                try realm.write {
                    userCity.name = name
                    userCity.country = country
                    userCity.latitude = latitude
                    userCity.longitude = longitude
                    realm.add(userCity, update: true)
                }
                debugPrint("user city updated:\(userCity.name)")
            }
            catch
            {
                debugPrint("can't update user city Value")
            }
        }
    }
    
    class func updateCityTemp(city_id:Int, celsius:Double, fahrenheit:Double)
    {
        do
        {
            let realm = try Realm()
            realm.refresh()
            if let city = realm.object(ofType: CityModel.self, forPrimaryKey: city_id)
            {
                try realm.write {
                    city.temp_celsius = celsius
                    city.temp_fahrenheit = fahrenheit
                    realm.add(city, update: true)
                }
                debugPrint("city updated:\(city.name)")
            }
        }
        catch
        {
            debugPrint("can't update city Value")
        }
    }
    
    //MARK: Delete Methods
    
    class func clearDatabase() {
        do {
            let realm = try Realm()
            realm.refresh()
            try realm.write {
                realm.deleteAll()
                debugPrint("all Database cleaned")
            }
        } catch {
            debugPrint("Error trying to clear the database")
        }
    }
    
    //MARK: Migrations
    class func databaseUpdate()
    {
        debugPrint("--->DBUpdate")
        // define a migration block
        // you can define this inline, but we will reuse this to migrate realm files from multiple versions
        // to the most current version of our data model
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < 1
            {
                /*
                 //---------------------------------------------------------------------//
                 //            THIS IS FOR ANY NEW CLASS OR COLUMN ADDED
                 //---------------------------------------------------------------------//
                 migration.enumerate("name class".className()) { oldObject, newObject in
                 // No-op.
                 // dynamic properties are defaulting the new column to true
                 // but the migration block is still needed
                 }
                 */
                
                //---------------------------------------------------------------------//
                //                          TO MIGRATION
                //---------------------------------------------------------------------//
                //-----------------------------------------------------------------------------------//
                // Change the value of DB_VERSION every time a change is made to the REALM database
                //-----------------------------------------------------------------------------------//
            }
            debugPrint("->oldSchemaVersion:\(oldSchemaVersion)")
            debugPrint("Migration complete.")
        }
        
        var config = Realm.Configuration(schemaVersion: DB_VERSION, migrationBlock: migrationBlock)
        config.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.weatherapp.extension")!.appendingPathComponent("db.realm")
        
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        debugPrint("--->Path to realm file:\(String(describing: Realm.Configuration.defaultConfiguration.fileURL?.path))")
        try! FileManager.default.setAttributes([FileAttributeKey.protectionKey:kCFURLFileProtectionNone], ofItemAtPath: (realm.configuration.fileURL?.path)!)
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
