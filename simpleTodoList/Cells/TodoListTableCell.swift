//
//  TodoListTableCell.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/30/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit

class TodoListTableCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ todoObject: TodoDataModel) {
       titleLabel.text = todoObject.name
//       dateLabel.text =
    }

}
