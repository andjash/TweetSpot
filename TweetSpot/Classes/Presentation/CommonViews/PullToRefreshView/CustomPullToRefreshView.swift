//
//  CustomPullToRefreshView.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit


extension UIScrollView {
    
    func ts_configurePullToRefresh(handler: () -> ()) {
        self.addPullToRefreshWithActionHandler(handler, position: .Top)
        self.pullToRefreshView .setCustomView(CustomPullToRefreshView.customPullToRefreshViewWithState(.ArrowUp), forState: .Triggered)
        self.pullToRefreshView .setCustomView(CustomPullToRefreshView.customPullToRefreshViewWithState(.ArrowDown), forState: .Stopped)
        self.pullToRefreshView .setCustomView(CustomPullToRefreshView.customPullToRefreshViewWithState(.Loading), forState: .Loading)
    }
    
}

class CustomPullToRefreshView: UIView {
    
    enum State {
        case Loading
        case ArrowUp
        case ArrowDown
    }
    
    var state = CustomPullToRefreshView.State.Loading
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    
    static func customPullToRefreshViewWithState(state: CustomPullToRefreshView.State) -> CustomPullToRefreshView {
        let result: CustomPullToRefreshView = CustomPullToRefreshView.ts_loadFromDefaultNib()
        result.state = state
        
        switch state {
        case .Loading:
            result.arrowImageView.hidden = true
            result.activityIndicator.startAnimating()
        case .ArrowUp:
            result.arrowImageView.image = UIImage(named: "CommonArrowUp")
            result.activityIndicator.hidden = true
        case .ArrowDown:
            result.arrowImageView.image = UIImage(named: "CommonArrowDown")
            result.activityIndicator.hidden = true
        }
        return result
    }
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        let alpha: CGFloat = newSuperview == nil ? 0 : 1
        UIView.animateWithDuration(0.3) { 
            self.arrowImageView.alpha = alpha
        }
    }
}
