//
//  TodoDataHelper.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/29/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit
import SQLite

protocol DataHelperProtocol {
    associatedtype T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?
}

/// Class TodoDataHelper supports DB functionality, such as create a table, insert an item, delete an item, select all items.

class TodoDataHelper: DataHelperProtocol {
    /// Table name
    static let TABLE_NAME = "Todo"
    /// table instance
    static let table = Table(TABLE_NAME)
    /// The id column, primary key
    static let id = Expression<Int64>("id")
    /// The title column
    static let name = Expression<String>("name")
    /// The date column
    static let date = Expression<Int64>("date")
    
    typealias T = TodoObject
    
    /// insert a table
    static func createTable() throws {
        guard let DB = SQLiteDBManager.sharedInstance.BBDB else {
            throw DataAccessError.datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(date)
            })
            
        } catch _ {
            // Error throw if table already exists
        }
        
    }
    
    /// insert an item
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDBManager.sharedInstance.BBDB else {
            throw DataAccessError.datastore_Connection_Error
        }
        if (item.name != nil && item.date != nil) {
            let insert = table.insert(name <- item.name!, date <- item.date!)
            do {
                let rowId = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.insert_Error
                }
                return rowId
            } catch _ {
                throw DataAccessError.insert_Error
            }
        }
        throw DataAccessError.nil_In_Data
    }
    
    /// update an item
    static func update(item: T) throws -> Int64 {
        guard let DB = SQLiteDBManager.sharedInstance.BBDB else {
            throw DataAccessError.datastore_Connection_Error
        }
        if let todoid = item.id {
            let query = table.filter(todoid == id)
            if let itemName = item.name, let itemDate = item.date {
                let update = query.update(name <- itemName, date <- itemDate)
                do {
                    let rowId = try DB.run(update)
                    guard rowId > 0 else {
                        throw DataAccessError.update_Error
                    }
                    return Int64(rowId)
                } catch _ {
                    throw DataAccessError.update_Error
                }
            }
        }
        throw DataAccessError.nil_In_Data
    }
    
    /// delete an item
    static func delete(item: T) throws -> Void {
        guard let DB = SQLiteDBManager.sharedInstance.BBDB else {
            throw DataAccessError.datastore_Connection_Error
        }
        if let todoid = item.id {
            let query = table.filter(todoid == id)
            do {
                let tmp = try DB.run(query.delete())
                guard tmp == 1 else {
                    throw DataAccessError.delete_Error
                }
            } catch _ {
                throw DataAccessError.delete_Error
            }
        }
    }
    
    /// retrieve an item with id
    static func find(todoid: Int64) throws -> T? {
        guard let DB = SQLiteDBManager.sharedInstance.BBDB else {
            throw DataAccessError.datastore_Connection_Error
        }
        let query = table.filter(todoid == id)
        let items = try DB.prepare(query)
        for item in  items {
            return TodoObject(id: item[id] , name: item[name], date: item[date])
        }
        
        return nil
    }
    
    /// retrieve all items in the table
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDBManager.sharedInstance.BBDB else {
            throw DataAccessError.datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table.order(date.desc))
        for item in items {
            retArray.append(TodoObject(id: item[id] , name: item[name], date: item[date]))
        }
        return retArray
        
    }
    
}
