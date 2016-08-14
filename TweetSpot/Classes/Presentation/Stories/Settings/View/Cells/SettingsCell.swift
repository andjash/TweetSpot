//
//  SettingsCell.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var valueSwitch: SettingsSwitch!
    
    static func cellHeight(withItem item: SettingsItem, tableWidth: CGFloat) -> CGFloat {
        let textHeight = item.name.ts_height(withFont: UIFont(name: "HelveticaNeue", size: 15)!, constrainedToWidth: tableWidth - 15 - 30 - 31 - 15)
        return max(10 + textHeight + 10 + 1, 44)
    }
}
