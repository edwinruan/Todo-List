//
//  SQLiteDataBase.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/29/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit
import SQLite


//enum DataAccessError: ErrorType {
//    case Datastore_Connection_Error
//    case Insert_Error
//    case Delete_Error
//    case Search_Error
//    case Nil_In_Data
//}



class SQLiteDataBase {
    static let sharedInstance = SQLiteDataBase()

    private init() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            let db = try Connection("\(path)/db.sqlite3")
        } catch {
            print("Connection Error: Failed to connect to DB")
        }
    }

    func createTables() throws{
        do {
//            try TeamDataHelper.createTable()
//            try PlayerDataHelper.createTable()
        } catch {
//            throw DataAccessError.Datastore_Connection_Error
        }

    }
}
