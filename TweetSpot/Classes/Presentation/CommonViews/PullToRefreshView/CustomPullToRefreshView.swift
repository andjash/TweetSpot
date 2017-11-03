//
//  CustomPullToRefreshView.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func ts_configurePullToRefresh(_ handler: @escaping () -> ()) {
        self.addPullToRefresh(actionHandler: handler, position: .top)
        self.pullToRefreshView.setCustom(CustomPullToRefreshView.customPullToRefreshViewWithState(.arrowUp), for: .triggered)
        self.pullToRefreshView.setCustom(CustomPullToRefreshView.customPullToRefreshViewWithState(.arrowDown), for: .stopped)
        self.pullToRefreshView.setCustom(CustomPullToRefreshView.customPullToRefreshViewWithState(.loading), for: .loading)
    }
    
}

final class CustomPullToRefreshView: UIView {
    
    enum State {
        case loading
        case arrowUp
        case arrowDown
    }
    
    private final var state = CustomPullToRefreshView.State.loading
    @IBOutlet final weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet final weak var arrowImageView: UIImageView!
    
    static func customPullToRefreshViewWithState(_ state: CustomPullToRefreshView.State) -> CustomPullToRefreshView {
        let result: CustomPullToRefreshView = CustomPullToRefreshView.ts_loadFromDefaultNib()
        result.state = state
        
        switch state {
        case .loading:
            result.arrowImageView.isHidden = true
            result.activityIndicator.startAnimating()
        case .arrowUp:
            result.arrowImageView.image = UIImage(named: "CommonArrowUp")
            result.activityIndicator.isHidden = true
        case .arrowDown:
            result.arrowImageView.image = UIImage(named: "CommonArrowDown")
            result.activityIndicator.isHidden = true
        }
        return result
    }
    
    // MARK: - UIView
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        let alpha: CGFloat = newSuperview == nil ? 0 : 1
        UIView.animate(withDuration: 0.3, animations: { 
            self.arrowImageView.alpha = alpha
        }) 
    }
}
