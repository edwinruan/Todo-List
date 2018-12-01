# Todo-List

A todo list iOS application with SQL database for persistent storage.

## Build
Build with Xcode 10 / Swift 4.2


### Prerequisites

These third-party functions are used:

* [SQLite.swift](https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#updating-rows)
* [SwiftLint](https://github.com/realm/SwiftLint)

### Installing

### Building Todo-List

To build Todo-List, you need a few a few standard iOS Development Tools:

1. [Xcode](https://developer.apple.com/xcode/) - Apple's suite of iOS and OS X development tools. 
2. [CocoaPods](http://cocoapods.org/) - The dependency manager for Cocoa projects.  Available by executing `$ sudo gem install cocoapods` in your terminal.

**Note:** Make sure to use CocoaPods >= 1.0.0.

#### Cloning & Preparing the Project

Once you have installed the prerequisites, you can proceed with cloning and configuring the project by executing the following commands in your terminal:

```sh
$ git clone --recursive  https://github.com/edwinruan/Todo-List
$ cd Todo-List
```

These commands will clone Todo-List from Github and then install all library dependencies via CocoaPods. Once these steps have completed without error, you can open the workspace by executing:

```sh
$ open "simpleTodoList.xcworkspace"
```
### Navigating the Project

The project is organized as detailed as below:

#### Model Class and DB related:
SQLiteDBManager:  represents the Data Base (DB) manager class to create a DB instance and start DB connection.
TodoDataHelper:  supports DB functionality, such as create a table, insert an item, delete an item, select all items.
TodoDataModel: represent the todo data model, includes todoObject id, name, created date.

#### ViewController:
TodoListVC: the todo list view controller and displays list of todo items.
TodoDetailVC: represents the todo detail view controller and handles add/update a todo item

#### Helper Class:
TodoAppHelper: provides helper class methods in this app
GlobalDateFormatter: represents custom DateFormatter class to convert among Date, millisecond epoch, and  Date String with different formats.


### DB related usage:
Create a Table:

```swift

       import SQLite

       let dataStore = SQLiteDBManager.sharedInstance
       do {
           try dataStore.createTables()
       } catch _ {
           print("Error")
       }

```

Query all items:
```swift
       do {
            try TodoDataHelper.findAll()
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }

```

Insert an item:
```swift
        do {
            let index = try TodoDataHelper.insert(item: object)
            
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
```

Update an item:
```swift
        do {
            let index = try TodoDataHelper.update(item: object)
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
```

Delete an item:
```swift
        do {
            try TodoDataHelper.delete(item: object)
        } catch {
            if let error = error as? DataAccessError {
                showAlert(error.getInternalMessage())
            }
        }
```
## Deployment

Add additional notes about how to deploy this on a live system


