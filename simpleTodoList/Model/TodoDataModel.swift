//
//  TodoDataModel.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/29/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit
import ObjectMapper

class TodoDataModel: NSObject, Mappable {
    
     var id: Int64?
     var name: String?
     var date: Int64?
    
    public init(todoObject: TodoObject) {
        id = todoObject.id
        name = todoObject.name
        date = todoObject.date
    }
    
    public required init?(map _: Map) {}
    
    open func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        date <- map["date"]
    }
    
    open class func newInstance(_ todoDict: [String: AnyObject]) -> TodoDataModel? {
        return Mapper<TodoDataModel>().map(JSON: todoDict)
    }
    
}

typealias TodoObject = (
    id: Int64?,
    name: String?,
    date: Int64?
)
