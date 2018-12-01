//
//  TodoListTableCell.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/30/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit

/// TodoListTableCell represents the todo list view table cell.
class TodoListTableCell: UITableViewCell {
    
    /// The title label displays title field of a todo item
    @IBOutlet var titleLabel: UILabel!
    
    /// The date label displays created date and time of a todo item
    @IBOutlet var dateLabel: UILabel!

    func configure(_ todoObject: TodoDataModel) {
        titleLabel.text = todoObject.name
        dateLabel.text = ""
        if let dateInt = todoObject.date {
            let dateNum = NSNumber(value: dateInt)
            if let dateString = TodoDateFormatter.stringForDateFormat(dateNum, format: DateFormat.MonthDayYearWithAtTime) {
                dateLabel.text = "Created " + dateString
            }
        }
    }

}
