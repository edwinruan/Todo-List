# Todo-List

A todo list iOS application with SQL database for persistent storage.

## Build
Build with Xcode 10 / Swift 4.2


### Prerequisites

These third-party functions are used:

* [SQLite.swift](https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#updating-rows)
* [SwiftLint](https://github.com/realm/SwiftLint)

### Installing

### Using [Homebrew](http://brew.sh/):

```
brew install Todo-List
```

### Using [CocoaPods](https://cocoapods.org):

Simply add the following line to your Podfile:

```ruby
pod 'Todo-List'
```

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


