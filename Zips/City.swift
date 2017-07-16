//
//  City.swift
//  Zips
//
//  Created by Lonnie Pierce on 6/23/17.
//  Copyright © 2017 Lonnie Pierce. All rights reserved.
//

import Foundation

class City {
    var CityID = 0;
    var CityName = ""
    var FirstChar = ""
    var ZipList = [String]()
    var CityList = [City]()
    var State = ""
    private var dbFilePath = ""
    private var IsConnectionOpen = false;
    private var database:OpaquePointer? = nil;

    init(){
        self.dbFilePath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])/zip.sqlite"
    }
    private func openConnection(){
        
        let results = sqlite3_open(self.dbFilePath, &database)
        
        if (results == SQLITE_OK) {
            IsConnectionOpen = true
            
            
        }
        else {
            IsConnectionOpen = false;
            sqlite3_close(database)
        }
        
    }
    public func setStateCityList(state: String)
    {
        self.CityList = []
        self.State = state
        var statement: OpaquePointer? = nil
        
        let sql = "SELECT DISTINCT substr(CITY,1,1) FIRST_CHAR,CITY FROM ZIP_TABLE INNER JOIN STATE_TABLE ON ZIP_TABLE.STATE = STATE_TABLE.ABBREVIATION WHERE lower(STATE_TABLE.STATE) = lower(\"" + state + "\") ORDER BY CITY; "
        openConnection()
        
        
        if(IsConnectionOpen == true) {
            if sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    let cityFirstChar = String(cString: sqlite3_column_text(statement, 0))
                    let cityName = String(cString: sqlite3_column_text(statement, 1))
                    let city = City()
                    
                    city.CityName = cityName
                    city.FirstChar = cityFirstChar
                    
                    CityList.append(city)
                    
                }
                
            }
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
        
        
    }

    public func setZipCodeList()
    {
        self.ZipList = []
        var statement: OpaquePointer? = nil
        let sql = "SELECT DISTINCT ZIP_CODE FROM ZIP_TABLE INNER JOIN STATE_TABLE ON ZIP_TABLE.STATE = STATE_TABLE.ABBREVIATION WHERE lower(CITY) = lower(\"" + self.CityName + "\") AND LOWER(STATE_TABLE.STATE) = lower(\"" + self.State + "\"); "
        openConnection()
        
        
        if(IsConnectionOpen == true) {
            if sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    let zipCode = String(cString: sqlite3_column_text(statement, 0))
                    self.ZipList.append(zipCode)
                }
                
            }
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
        
        
    }
    public func getSectionedCities() -> [String: [String]]
    {
        let firstKey = CityList[0].FirstChar
        var previousKey = ""
        let lastKey = self.CityList[CityList.count - 1].FirstChar
        var cityList = [String]()
        var cityKeyValues = [String: [String]]()
        CityList.forEach{ city in
            
            
            if (city.FirstChar.contains(firstKey) || city.FirstChar.contains(previousKey) )
            {
                cityList.append(city.CityName)
            
            }
            else
            {
                if(city.FirstChar.contains(lastKey))
                {
                    //Execute on last city in list
          
                    cityList.append(city.CityName)
                    cityKeyValues[lastKey] = cityList
                }
                else{
                    //Execute when index of list changes
                    cityKeyValues[previousKey] = cityList
                    cityList = [];
                   
                    cityList.append(city.CityName)
                    
                }
            }
            
            previousKey = city.FirstChar
            
        }
        
        return cityKeyValues
    }

}
