//
//  String+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

extension String {
    func ts_localized(table: String) -> String {
        return NSLocalizedString(self, tableName: table, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}
