//
//  TodoDataModel.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/29/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit

/// Class TodoDataModel represent the todo data model, includes id, name, create date,
class TodoDataModel: NSObject {
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
