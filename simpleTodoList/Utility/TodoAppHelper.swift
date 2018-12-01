//
//  TodoAppHelper.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/30/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit

extension String {
    public func stringIsAllwhiteSpace() -> Bool {
        let characterSet: CharacterSet = CharacterSet.whitespacesAndNewlines
        if trimmingCharacters(in: characterSet).isEmpty {
            return true
        }
        return false
    }
    
}

