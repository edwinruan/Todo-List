//
//  TodoListVC.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/29/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit
import SQLite


/// TodoListVC represents the todo list view controller
class TodoListVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    
    var todoItems = [TodoDataModel]()
    let refreshControl = UIRefreshControl()
    let defaultTitle = "Todo List"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        
        let dataStore = TodoDBManager.sharedInstance
        do {
            try dataStore.createTables()
        } catch _ {
            print("Error")
        }
        retrieveAllRecords()
    }
    
    func configureNavigationBar() {
        setTitleText()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addTodoItem))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.title = ""
    }
    
    func setTitleText() {
        let numberOfItem = " (" + "\(todoItems.count)" + ")"
        if todoItems.count > 0 {
            navigationItem.title = defaultTitle + numberOfItem
        } else {
            navigationItem.title = defaultTitle
        }
    }
    
    func configureTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(TodoListVC.refreshControlAction), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refreshControlAction() {
        refreshControl.beginRefreshing()
        retrieveAllRecords()
    }
    
    @objc func addTodoItem() {
        let todoDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "TodoDetailVC") as! TodoDetailVC
        todoDetailVC.delegate = self
        todoDetailVC.viewmode = .add
        let navi = UINavigationController(rootViewController: todoDetailVC)
        self.present(navi, animated: true, completion: nil)
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

// - MARK: - UITableView Data Source

extension TodoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard todoItems.indices.contains(indexPath.row) else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListTableCell", for: indexPath) as? TodoListTableCell {
            cell.configure(todoItems[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// - MARK: - UITableView Delegate

extension TodoListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        guard todoItems.indices.contains(indexPath.row) else { return }
        let todoDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "TodoDetailVC") as! TodoDetailVC
        todoDetailVC.delegate = self
        todoDetailVC.viewmode = .update
        todoDetailVC.todoItem = todoItems[indexPath.row]
        self.navigationController?.pushViewController(todoDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard todoItems.indices.contains(indexPath.row) else { return }
            self.deleteItem(object: self.todoItems[indexPath.row].convertTodoObject(), indexPath: indexPath)
        }
    }
}

// - MARK: - TodoDetailVC Delegate

extension TodoListVC: TodoDetailVCDelegate {
    func todoDetailDidUpdate() {
        retrieveAllRecords()
    }
}

// Mark: - DB update methods

extension TodoListVC {
    func retrieveAllRecords() {
        do {
            if let todos = try TodoDBManager.sharedInstance.findAll() {
                todoItems.removeAll()
                for item in todos {
                    todoItems.append(TodoDataModel(todoObject: item))
                }
                if todoItems.isEmpty {
                    emptyView.isHidden = false
                } else {
                    emptyView.isHidden = true
                }
                setTitleText()
                tableView.reloadData()
                refreshControl.endRefreshing()
            }
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
    }
    
    func deleteItem(object: TodoObject, indexPath: IndexPath) {
        do {
            try TodoDBManager.sharedInstance.delete(item: object)
            self.todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if todoItems.isEmpty {
                emptyView.isHidden = false
            } else {
                emptyView.isHidden = true
            }
            setTitleText()
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
    }
    
}
