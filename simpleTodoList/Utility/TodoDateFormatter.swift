//
//  TodoDateFormatter.swift
//  simpleTodoList
//
//  Created by Rush01 on 11/30/18.
//  Copyright © 2018 Rush01. All rights reserved.
//

import UIKit

/// Class TodoDateFormatter represents custom DateFormatter class to convert among Date, millisecond epoch, and  Date String with different formats.
class TodoDateFormatter {
    class func stringForDateFormat(_ dateInMillis: NSNumber?, format: DateFormat) -> String? {
        if let dateInMillis = dateInMillis {
            let date: Date = Date(timeIntervalSince1970: round(Double(truncating: dateInMillis) / 1_000))
            return stringFromDate(date, format: format)
        } else {
            return nil
        }
    }
    
    open class func convertToDate(_ dateInMillis: NSNumber?) -> Date? {
        if let dateInMillis = dateInMillis {
            return Date(timeIntervalSince1970: round(Double(truncating: dateInMillis) / 1_000))
        }
        return nil
    }
    
    open class func convertToDateInMillis(_ date: Date?) -> NSNumber? {
        if let date = date {
            return NSNumber(value: round(date.timeIntervalSince1970 * 1_000) as Double)
        }
        return nil
    }
    
    open class func stringFromDate(_ date: Date, format: DateFormat) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
}

/// DateFormat enum for different formats in Date string
public enum DateFormat: String {
    case MMMdyyyyhmma = "MMM d, yyyy h:mm a"
    case hhmma = "hh:mm a"
    case EEEEMMMddhmma = "EEEE MMM dd, h:mm a"
    case MonthDayYearWithAtTime = "MMM dd, yyyy 'at' h:mm a"
    
}
