//
//  Logger.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

let log = Logger()

final class Logger {
    
    final func verbose(_ str: String) {
        print(str)
    }
    
    final func error(_ str: String) {
        print(str)
    }
    
    final func severe(_ str: String) {
        print(str)
    }
    
    final func debug(_ str: String) {
        print(str)
    }
    
}
