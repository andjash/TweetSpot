//
//  NSDateFormatter+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 15/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

extension NSDateFormatter {

    func ts_configureAsAppCommonFormatter() {
        dateFormat = "dd.MM.yy HH:mm"
    }
    
}