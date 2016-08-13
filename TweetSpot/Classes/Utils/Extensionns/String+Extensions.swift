//
//  String+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

extension String {
    func ts_localized(table: String) -> String {
        return NSLocalizedString(self, tableName: table, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    func ts_height(withFont font: UIFont, constrainedToWidth: CGFloat) -> CGFloat {
        let rect = (self as NSString).boundingRectWithSize(CGSize(width: constrainedToWidth, height: CGFloat.max),
                                                           options: .UsesLineFragmentOrigin,
                                                           attributes: [NSFontAttributeName : font],
                                                           context: nil)
        return ceil(rect.height)
    }
}
