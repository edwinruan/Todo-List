//
//  TodoDetailVC.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/30/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit

public enum TodoDetailVCMode: String {
    case add
    case update
    
    var description: String {
        switch self {
        case .add:
            return "Add item"
        case .update:
            return "Edit item"
        }
    }
    
    var rightBarButtonText: String {
        switch self {
        case .add:
            return "Add"
        case .update:
            return "Update"
        }
    }

}

protocol TodoDetailVCDelegate: class {
    func todoDetailDidUpdate()
}

/// TodoListVC represents the todo detail view controller and handles add/update a todo item
class TodoDetailVC: UIViewController {
    
    @IBOutlet var metadataLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var metadataLabelHeight: NSLayoutConstraint!
    
    weak var delegate: TodoDetailVCDelegate?
    var todoItem = TodoDataModel()
    var viewmode = TodoDetailVCMode.add
    var defaultMetadataLabelHeight: CGFloat = 20
    let placeHolderDescription = "Type in what you plan to do? E.g. Buy milk"
    let discardMessage: String = "If you go back now all changes you've made will be lost"
    let discardTitle: String = "Discard Changes?"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func configureNavigationBar() {
        self.title = viewmode.description
        navigationItem.rightBarButtonItem = getRightBarButton(false, name: viewmode.rightBarButtonText)
        switch viewmode {
        case .add:
             self.navigationItem.leftBarButtonItem = closeButton()
        case .update:
             self.navigationItem.leftBarButtonItem = backButton()
        }
    }
    
    func configureTextView() {
        textView.text = todoItem.name
        metadataLabel.text = ""
        if let dateInt = todoItem.date {
            metadataLabelHeight.constant = defaultMetadataLabelHeight
            let dateNum = NSNumber(value: dateInt)
            if let dateString = GlobalDateFormatter.stringForDateFormat(dateNum, format: DateFormat.MonthDayYearWithAtTime) {
                metadataLabel.text = "Last updated at " + dateString
            }
        } else {
            metadataLabelHeight.constant = 0
        }
    }
    
    func closeButton() -> UIBarButtonItem {
        let closeBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close_nav", in: Bundle.main, compatibleWith: nil), style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissVC))
        return closeBtn
    }
    
    func backButton() -> UIBarButtonItem {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back_nav", in: Bundle.main, compatibleWith: nil), style: UIBarButtonItem.Style.done, target: self, action: #selector(popbackVC))
        return backButton
    }
    
    @objc func dismissVC() {
        if navigationItem.rightBarButtonItem?.isEnabled == true {
             showCancelAlertVC()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func popbackVC() {
        if navigationItem.rightBarButtonItem?.isEnabled == true {
            showCancelAlertVC()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func getRightBarButton(_ enable: Bool, name: String) -> UIBarButtonItem {
        let addBtn: UIBarButtonItem = UIBarButtonItem(title: name, style: .plain, target: self, action: #selector(addUpdateTodoObject))
        addBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .disabled)
        addBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: UIControl.State())
        addBtn.isEnabled = enable
        return addBtn
    }
    
    // add update todo Object
    @objc func addUpdateTodoObject() {
        todoItem.name = textView.text
        if let dateNum = GlobalDateFormatter.convertToDateInMillis(Date()) {
            todoItem.date = dateNum.int64Value
        }
        
        switch viewmode {
        case .add:
            insertItem(object: todoItem.convertTodoObject())
        case .update:
            updateItem(object: todoItem.convertTodoObject())
        }
    }
}

// - MARK: - UITextView Delegate

extension TodoDetailVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.stringIsAllwhiteSpace() == false && textView.text != todoItem.name {
             navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
             navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

}

// - MARK: - Alert View Helper method

extension TodoDetailVC {
    /// show an alert view for discard unsaved changes
    func showCancelAlertVC() {
        let alertController: UIAlertController = UIAlertController(title: discardTitle, message: discardMessage, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (_) -> Void in
        }
        
        let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Discard", comment: ""), style: .destructive) { (_) -> Void in
            switch self.viewmode {
            case .add:
                _ = self.dismiss(animated: true, completion: nil)
            case .update:
                _ = self.navigationController?.popViewController(animated: true)
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// show an alert view
    func showAlert(_ title: String, message: String = "", completionBlock: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) { _ in
            if let completionBlock = completionBlock {
                completionBlock()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    /// show an auto dismiss alert view
    func showFlashAlert(_ title: String, message: String, interval: Double, shouldDismissController: Bool = true) {
        let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Present the AlertController
        present(actionSheetController, animated: true) {
            if shouldDismissController {
                Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(TodoDetailVC.closeAlertAndSuperview), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func closeAlertAndSuperview() {
        dismiss(animated: true) { () -> Void in
            if let taskId = self.todoItem.id, taskId > 0 { // update item
                _ = self.navigationController?.popViewController(animated: true)
            } else { // add item
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// - MARK: - DB related method

extension TodoDetailVC {
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
    
    func insertItem(object: TodoObject) {
        do {
            let index = try TodoDataHelper.insert(item: object)
            findWithId(todoId: index)
            if let delegate = delegate {
                delegate.todoDetailDidUpdate()
            }
            showFlashAlert("Item was added", message: "", interval: 1.0, shouldDismissController: true)
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
            if let delegate = delegate {
                delegate.todoDetailDidUpdate()
            }
            showFlashAlert("Item was updated", message: "", interval: 1.0, shouldDismissController: true)
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
    }
}
