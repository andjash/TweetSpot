//
//  TweetDetailsTweetDetailsViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class TweetDetailsViewController: UIViewController {

    final var output: TweetDetailsPresenter!
    
    @IBOutlet final weak var scrollView: UIScrollView!
    @IBOutlet final weak var scrollContentheight: NSLayoutConstraint!
    
    @IBOutlet final weak var blurImageView: UIImageView!
    @IBOutlet final weak var profileImageView: UIImageView!
    @IBOutlet final weak var imagesContainer: UIView!
    
    @IBOutlet final weak var nameLabel: UILabel!
    @IBOutlet final weak var datelabel: UILabel!
    @IBOutlet final weak var textLabel: UILabel!
    
    final var currentItem: TweetDetailsViewModel?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.ts_applicationPrimaryColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        imagesContainer.backgroundColor = UIColor(white: 0, alpha: 0.05)
    
        blurImageView.layer.masksToBounds = true
        profileImageView.layer.masksToBounds = true
        
        if let item = currentItem {
            decorateWithItem(item)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let item = currentItem {
            let textHeight = item.text.ts_height(with: UIFont(name: "HelveticaNeue-Light", size: 20)!, constrained: view.frame.width - 10 - 10)
            let contentHeight: CGFloat = imagesContainer.frame.height + nameLabel.frame.height + datelabel.frame.height + textHeight + 10
            scrollContentheight.constant = contentHeight
            scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
        }
        
        self.updateContentModeOnProfileImageView()
        
    }
    
    // MARK: - Input
    
    final func configureWithItem(_ item: TweetDetailsViewModel) {
        currentItem?.avatarRetrievedCallback = nil
        currentItem?.smallAvatarRetrievedCallback = nil
        currentItem = item
        
        if isViewLoaded {
            decorateWithItem(item)
        }
    }
    
    // MARK: - Private
    
    final func decorateWithItem(_ item: TweetDetailsViewModel) {
        title = "@\(item.screenName)"
        
        if let small = item.smallAvatar {
            decorateWithSmallAvatar(small)
        } else {
            item.smallAvatarRetrievedCallback = {[weak self] in
                item.smallAvatarRetrievedCallback = nil
                if let strongSelf = self {
                    strongSelf.decorateWithSmallAvatar(item.smallAvatar)
                }
            }
        }
        
        if let big = item.bigAvatar {
            decorateWithBigAvatar(big)
        } else {
            item.avatarRetrievedCallback = {[weak self] in
                item.avatarRetrievedCallback = nil
                if let strongSelf = self {
                    strongSelf.decorateWithBigAvatar(item.bigAvatar)
                }
            }
        }
        
        
        nameLabel.text = item.userName
        datelabel.text = item.formattedPostDate
        textLabel.text = item.text
    }
    
    final func decorateWithSmallAvatar(_ img: UIImage?) {
        guard let image = img else { return }
        blurImageView.alpha = 0
        
        blurImageView.image = image
       
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = blurImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurImageView.addSubview(blurEffectView)
        }
        UIView.animate(withDuration: 0.3) {
            self.blurImageView.alpha = 1
        }
    }
    
    final func decorateWithBigAvatar(_ img: UIImage?) {
        guard let image = img else { return }
        profileImageView.alpha = 0
        
        profileImageView.image = image
        self.updateContentModeOnProfileImageView()
        
        UIView.animate(withDuration: 0.3) {
            self.profileImageView.alpha = 1
        }
    }
    
    final func updateContentModeOnProfileImageView() {
        guard let image = profileImageView.image else { return }
        
        if image.size.width > profileImageView.frame.width ||
            image.size.height > profileImageView.frame.height {
            profileImageView.contentMode = .scaleAspectFit
        } else {
            profileImageView.contentMode = .center
        }
    }

}
