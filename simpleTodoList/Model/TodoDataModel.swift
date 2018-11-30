//
//  TodoDataModel.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/29/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit
import ObjectMapper

/// Class TodoDataModel represent the todo data model, includes id, name, create date,
class TodoDataModel: NSObject, Mappable {
     /// The id field of todo item
     var id: Int64?
     /// The title of todo item
     var name: String?
     /// The created date of todo item
     var date: Int64?
    
    /// initalize a TodoDataModel from a TodoObject
    public init(todoObject: TodoObject) {
        id = todoObject.id
        name = todoObject.name
        date = todoObject.date
    }
    
    override init() {
        super.init()
    }
    
    public required init?(map _: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        date <- map["date"]
    }
    
    /// create a new TodoDataModel instance
    class func newInstance(_ todoDict: [String: AnyObject]) -> TodoDataModel? {
        return Mapper<TodoDataModel>().map(JSON: todoDict)
    }
    
    /// convert a TodoDataModel to TodoObject for DB storage purpose
    func convertTodoObject() -> TodoObject {
        return (id: id, name: name, date: date)
    }
    
}

typealias TodoObject = (
    id: Int64?,
    name: String?,
    date: Int64?
)
