//
//  SpotTweetItemCell.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class SpotTweetItemCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var avatarRightSpace: NSLayoutConstraint!
    
    static func cellHeight(withItem item: SpotTweetItem, displayingAvatar: Bool, tableWidth: CGFloat) -> CGFloat {
        var result: CGFloat = 0
        if displayingAvatar {
            let textHeight = item.text.ts_height(withFont: UIFont(name: "HelveticaNeue", size: 14)!, constrainedToWidth: tableWidth - 10 - 10 - 50 - 10)
            result = 5 + max(50 , textHeight + 17) + 14 + 5
        } else {
            let textHeight = item.text.ts_height(withFont: UIFont(name: "HelveticaNeue", size: 14)!, constrainedToWidth: tableWidth - 10 - 10)
            result = 5 + max(40 , textHeight + 17) + 14 + 5
        }
        return result + 1
    }
    
    func bindItem(item: SpotTweetItem, displayAvatar: Bool) {
        dateLabel.text = item.formattedPostDate
        nameLabel.text = item.userName
        screenNameLabel.text = item.screenName
        tweetTextLabel.text = item.text
        
        if displayAvatar {
            avatarContainerWidth.constant = 60
            avatarRightSpace.constant = 10
            if let img = item.avatar {
                avatarImageView.backgroundColor = UIColor.clearColor()
                avatarImageView.image = img
            } else {
                avatarImageView.backgroundColor = UIColor(white: 0, alpha: 0.1)
            }
        } else {
            avatarRightSpace.constant = 0
            avatarContainerWidth.constant = 0
        }
    }
    
    override var layoutMargins: UIEdgeInsets {
        set {}
        get {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    

}
