//
//  String+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

extension String {
    
    func ts_localized(_ table: String) -> String {
        return NSLocalizedString(self, tableName: table, bundle: Bundle.main, value: "", comment: "")
    }
    
    func ts_height(withFont font: UIFont, constrainedToWidth: CGFloat) -> CGFloat {
        let rect = (self as NSString).boundingRect(with: CGSize(width: constrainedToWidth, height: CGFloat.greatestFiniteMagnitude),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [NSAttributedStringKey.font : font],
                                                           context: nil)
        return ceil(rect.height)
    }
}
