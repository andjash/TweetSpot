//
//  NSDate+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

extension NSDate {
    
    var ts_isToday: Bool {
        let calendar = NSCalendar.currentCalendar()
        var dateComponents = calendar.components([.Era, .Year, .Month, .Day], fromDate: NSDate())
        let today = calendar.dateFromComponents(dateComponents)
        
        dateComponents = calendar.components([.Era, .Year, .Month, .Day], fromDate: self)
        let currentDate = calendar.dateFromComponents(dateComponents)
        
        return today == currentDate
    }
}
