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

class TodoDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Todo"
    
    static let table = Table(TABLE_NAME)
    static let id = Expression<Int64>("id")
    static let name = Expression<String>("name")
    static let date = Expression<Int64>("date")

    
    typealias T = TodoObject
    
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
    
    static func delete (item: T) throws -> Void {
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
