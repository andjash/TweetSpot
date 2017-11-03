//
//  SettingsCell.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class SettingsCell: UITableViewCell {

    @IBOutlet final weak var settingTitleLabel: UILabel!
    @IBOutlet final weak var valueSwitch: SettingsSwitch!
    
    static func cellHeight(with item: SettingsItem, tableWidth: CGFloat) -> CGFloat {
        let textHeight = item.name.ts_height(with: UIFont(name: "HelveticaNeue", size: 15)!, constrained: tableWidth - 15 - 30 - 31 - 15)
        return max(10 + textHeight + 10 + 1, 44)
    }
}
