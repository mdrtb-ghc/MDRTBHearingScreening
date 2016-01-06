//
//  UtilityFunctions.swift
//  test
//
//  Created by Laura Greisman on 3/24/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

let JSONDateFormat : String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
let PrettyDateFormat : String = "yyyy/MM/dd HH:mm"

func dateToJSONString(date: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = JSONDateFormat
    let dateString = dateFormatter.stringFromDate(date)
    return dateString
}

func JSONStringToDate(dateString: String?) -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = JSONDateFormat
    let date = dateFormatter.dateFromString(dateString ?? "")
    return date
}

func JSONDateSplitComponents(dateString: String?) -> [String] {
    if (dateString != nil) {
        var arr = dateString!.componentsSeparatedByString("T")
        let splitDate = arr[0].componentsSeparatedByString("-")
        let splitTime = arr[1].componentsSeparatedByString(":")
        return splitDate + splitTime
    }
    return []
}

func JSONDateYearOnly(dateString: String?) -> String {
    return JSONDateSplitComponents(dateString).first ?? ""
}
func JSONDateDateOnly(dateString: String?) -> String {
    if (dateString != nil) {
        let arr = dateString!.componentsSeparatedByString("T")
        return arr.first ?? ""
    }
    return ""
}

func JSONDateTimeOnly(dateString: String?) -> String {
    if (dateString != nil) {
        let arr = dateString!.componentsSeparatedByString("T")
        return arr.last ?? ""
    }
    return ""
}

// Returns 'Pretty Date'
func JSONDatePrettyString(dateString: String?) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = PrettyDateFormat
    
    if let date = JSONStringToDate(dateString) {
        return dateFormatter.stringFromDate(date)
    } else {
        return dateString ?? ""
    }
}
