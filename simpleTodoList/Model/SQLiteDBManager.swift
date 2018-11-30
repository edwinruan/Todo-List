//
//  SQLiteDBManager.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/29/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit
import SQLite


// Data base access error type
enum DataAccessError: Error {
    case datastore_Connection_Error
    case insert_Error
    case update_Error
    case delete_Error
    case search_Error
    case nil_In_Data
    
    func getInternalMessage() -> String {
        switch self {
        case .datastore_Connection_Error: return "Not able to connect to database"
        case .insert_Error: return "Not able to insert selected item to database, please try again"
        case .update_Error: return "Not able to update selected item, please try again"
        case .delete_Error: return  "Not able to delete selected item, please try again"
        case .search_Error: return  "Not able to search selected item, please search again"
        case .nil_In_Data: return "Insert data is invalid"
        }
    }
}

/// This class represents the Data Base (DB) manager class to create a DB instance and start DB connection.
class SQLiteDBManager {
     /// DB singleton
    static let sharedInstance = SQLiteDBManager()
    /// DB connection
    let BBDB: Connection?
    
    /* private initilization method, will attempt to create the database file if it does not already exist. A connection is initialized with a path to a database.
     */
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        let fullPath = "\(path)/db.sqlite3"
        do {
            let db = try Connection(fullPath)
        } catch {
            print("Connection Error: Failed to connect to DB")
        }
        
        do {
            BBDB = try Connection(fullPath)
        } catch _ {
            BBDB = nil
        }
    }

     /// createtable method, will call createtable method in TodoDataHelper
    func createTables() throws {
        do {
            try TodoDataHelper.createTable()
        } catch {
            throw DataAccessError.datastore_Connection_Error
        }
    }
}
