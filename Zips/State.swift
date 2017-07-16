//
//  State.swift
//  Zips
//
//  Created by Lonnie Pierce on 6/23/17.
//  Copyright © 2017 Lonnie Pierce. All rights reserved.
//

import Foundation
import UIKit


class State  {
    var StateID = 0
    var StateName = ""
    var CityFirstChar = ""
    var StateFirstChar = ""
    var StateAbbreviation = ""
    
    private var dbFilePath = ""
    private var IsConnectionOpen = false;
    private var database:OpaquePointer? = nil;
  
    var StateList:[State] = []
    var CityList:[City] = []
  
    init() {
        
        
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
    func setStateList() {
        self.StateList = []
        openConnection()
        
        var statement: OpaquePointer? = nil
        let sql = "SELECT ID,substr(State,1,1) FIRST_CHAR, State,Abbreviation FROM STATE_TABLE ORDER BY STATE"
        
        if(IsConnectionOpen == true) {
            if sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    let id = Int(sqlite3_column_int(statement,0))
                    let stateFirstChar = String(cString: sqlite3_column_text(statement, 1))
                    let stateName = String(cString: sqlite3_column_text(statement, 2))
                    let stateAbbreviation = String(cString: sqlite3_column_text(statement, 3))
                    
                    let state = State()
                    state.StateFirstChar = stateFirstChar
                    state.StateName = stateName
                    state.StateAbbreviation = stateAbbreviation
                    state.StateID = id
                    
                    StateList.append(state)
                  
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(database)
        }
        
    }
    public func getSectionedStates() -> [String: [String]]
    {
        var currentKey = "A"
        var stateList = [String]()
        var stateKeyValue = [String: [String]]()
        StateList.forEach{ state in
            
            if (state.StateFirstChar == currentKey)
            {
                stateList.append(state.StateName)
            }
            else
            {
                stateKeyValue[currentKey] = stateList
                stateList = [];
                currentKey = state.StateFirstChar
                stateList.append(state.StateName);
            }
        }
        
        return stateKeyValue
    }
    public func findFile()
    {
        
        let bundle = Bundle.init(identifier: "com.lpeazy.Zips.Zips")
        let sourceFilePath = bundle?.path(forResource: "zip", ofType: ".sqlite") as! String
        var doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! String
        let destinationPath =  doumentDirectoryPath.appending("/zip.sqlite")
        
        // let j = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .allDomainsMask, true)//+"/Zips.app"
        //let bundle = Bundle.main
        let fileManager = FileManager.default
        let fileExists = fileManager.fileExists(atPath: destinationPath)
        
     
        //let file = Bundle.path(forResource: "file", ofType: "txt", inDirectory: String(describing: j))
        //let exists = fileManager.fileExists(atPath: String(describing: file))
        
        
        //path(forResource: "file", ofType : "txt"?)
      
        //var filePath = Bundle.main.infoDictionary
        //var filePath = Bundle.main.url(forResource: "file", withExtension: "txt")
        //let exists = fileManager.fileExists(atPath: String(describing: filePath))
        //let sourcePath = "/Zips/zips.sqlite"
        do {
            
            if(!fileExists)
            {
               try fileManager.copyItem(atPath: sourceFilePath, toPath: destinationPath)
            }
            
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
       
        return true
    }
        
}
