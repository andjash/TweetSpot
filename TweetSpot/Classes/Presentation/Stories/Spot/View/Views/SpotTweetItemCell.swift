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
    @IBOutlet weak var avatarUnderlay: UIView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var avatarRightSpace: NSLayoutConstraint!
    
    var currentItem: SpotTweetItem?
    
    static func cellHeight(withItem item: SpotTweetItem, displayingAvatar: Bool, tableWidth: CGFloat) -> CGFloat {
        var result: CGFloat = 0
        if displayingAvatar {
            let textHeight = item.text.ts_height(withFont: UIFont(name: "HelveticaNeue", size: 14)!, constrainedToWidth: tableWidth - 10 - 10 - 36 - 10)
            result = 5 + max(36 , textHeight + 17) + 14 + 5
        } else {
            let textHeight = item.text.ts_height(withFont: UIFont(name: "HelveticaNeue", size: 14)!, constrainedToWidth: tableWidth - 10 - 10)
            result = 5 + max(36 , textHeight + 17) + 14 + 5
        }
        return result + 1
    }
    
    deinit {
        currentItem?.avatarRetrievedCallback = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarUnderlay.backgroundColor = UIColor(white: 0, alpha: 0.05)
        avatarUnderlay.layer.cornerRadius = 3.0
        avatarImageView.layer.cornerRadius = 3.0
        avatarImageView.clipsToBounds = true
    }
    
    func bindItem(item: SpotTweetItem, displayAvatar: Bool) {
        currentItem?.avatarRetrievedCallback = nil
        currentItem = item
        dateLabel.text = item.formattedPostDate
        nameLabel.text = item.userName
        screenNameLabel.text = "@\(item.screenName)"
        tweetTextLabel.text = item.text
        avatarImageView.image = nil
        avatarImageView.alpha = 0
        if displayAvatar {
            avatarContainerWidth.constant = 46
            avatarRightSpace.constant = 10
            if let img = item.avatar {
                avatarImageView.image = img
                avatarImageView.alpha = 1
            } else {
                item.avatarRetrievedCallback = {[weak self] in
                    if let strongSelf = self {
                        strongSelf.avatarImageView.image = strongSelf.currentItem?.avatar
                        UIView.animateWithDuration(0.3, animations: { 
                            strongSelf.avatarImageView.alpha = 1
                        })
                    }
                }
            }
        } else {
            avatarRightSpace.constant = 0
            avatarContainerWidth.constant = 0
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override var layoutMargins: UIEdgeInsets {
        set {}
        get {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    

}
