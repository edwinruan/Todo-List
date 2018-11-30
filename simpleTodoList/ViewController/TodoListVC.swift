//
//  TodoListVC.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/29/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit
import SQLite

class TodoListVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var todoItems = [TodoDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        let dataStore = SQLiteDBManager.sharedInstance
        do {
            try dataStore.createTables()
//            setData()
        } catch _ {
            print("Error")
        }
//        let object = TodoObject(id: 6, name: "TODO 5 ", date: "Jul 22, 2017")
//        updateItem(object: object)
//        insertItem(object: object)
//        deleteItem(object: object)
        findAll()
//       findWithId(todoId: 1)
        
        print("Finish")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    func setData() {
        do {
            let todoId1 = try TodoDataHelper.insert(
                item: TodoObject (
                    id: 1,
                    name: "TODO 1 ",
                    date: 1_543_594_218_145))

            
            let todoId2 = try TodoDataHelper.insert(
                item: TodoObject (
                    id: 2,
                    name: "TODO 2 ",
                    date: 1_543_594_218_045))
            
            let todoId3 = try TodoDataHelper.insert(
                item: TodoObject (
                    id: 3,
                    name: "TODO 3 ",
                    date: 1_543_594_218_002))
        } catch _{}
    }
    
    
    func showAlert(_ message: String, completionBlock: (() -> Void)? = nil) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) { _ in
            if let completionBlock = completionBlock {
                completionBlock()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}

extension TodoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableCell", for: indexPath) as? TodoListTableCell {
            cell.configure(todoItems(indexPath.row))
            return cell
        }
        return UITableViewCell()
    }
}

extension TodoListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

extension TodoListVC {
    func findAll() {
        do {
            if let todos = try TodoDataHelper.findAll() {
                todoItems.removeAll()
                for item in todos {
                    todoItems.append(TodoDataModel(todoObject: item))
                }
                tableView.reloadData()
            }
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
    }
    
    func findWithId(todoId: Int64) {
        do {
            if let item = try TodoDataHelper.find(todoid: todoId) {
                    print(item)
            }
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
    }
    
    func updateItem(object: TodoObject) {
        do {
            let index = try TodoDataHelper.update(item: object)
            findWithId(todoId: index)
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
    }
    
    func insertItem(object: TodoObject) {
        do {
            let index = try TodoDataHelper.insert(item: object)
            findWithId(todoId: index)
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
    }
    
    func deleteItem(object: TodoObject) {
        do {
            try TodoDataHelper.delete(item: object)
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
    }
    
}
