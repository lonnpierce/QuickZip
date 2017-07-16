//
//  Data.swift
//  Zips
//
//  Created by Lonnie Pierce on 6/26/17.
//  Copyright © 2017 Lonnie Pierce. All rights reserved.
//

import Foundation
import CoreData

class Data {
    var dbFilePath = ""
    var IsConnectionOpen = false;
    var database:OpaquePointer? = nil;
    
    init() {
       
        //fileManager.copyItem(URL(sourcePath),URL(destinationPath))
        //FileManager.copyItem(at: URL(sourcePath),to: URL(destinationPath))
    }
    public func openConnection(){
       
       let results = sqlite3_open(self.dbFilePath, &database)
    
        
        if (results == SQLITE_OK) {
            IsConnectionOpen = true
            
         
        }
        else {
            IsConnectionOpen = false;
            sqlite3_close(database)
        }
        
        }
    func setDbFilePath()
    {
        
        self.dbFilePath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])/zip.sqlite"
     }
     func executeQuery(sql: String) -> String {
        openConnection()
        var results = ""
        var statement: OpaquePointer? = nil
     
        if(IsConnectionOpen == true) {
                if sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK {
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        let row = String(cString: sqlite3_column_text(statement, 0))
                        //String(row: String.Encoding.utf8,
                        results += "\(row),"
                    }
                }
            sqlite3_finalize(statement)
           
        }
        //results = results.trimmingCharacters(",")
        sqlite3_close(database)
        print(results)
        return results
    }
    
}
