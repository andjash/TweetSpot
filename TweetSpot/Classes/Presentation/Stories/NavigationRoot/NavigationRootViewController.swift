//
//  NavigationRootNavigationRootViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class NavigationRootViewController: UIViewController  {

    final var output: NavigationRootPresenter!
    
    @IBOutlet final weak var titleLabel: UILabel!
    @IBOutlet final weak var birdLabel: UILabel!
    @IBOutlet final weak var birdLabelHorizontalAlign: NSLayoutConstraint!
    @IBOutlet final weak var verifyingLabel: UILabel!
    @IBOutlet final weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet final weak var gradientView: UIView!
    final weak var gradientLayer: CAGradientLayer!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ts_applicationPrimaryColor
        self.verifyingLabel.text = "root_verifying_account".ts_localized("Root")
        
        let gLayer = CAGradientLayer.ts_applicationPrimaryGradient
        gradientView.layer.addSublayer(gLayer)
        gradientLayer = gLayer
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewIsAppeared()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        verifyingLabel.alpha = 0
        activityIndicator.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = gradientView.bounds
    }
    
    // MARK: - Input
    
    final func showAppLaunchAnimation(_ completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gradientView.alpha = 1
            self.titleLabel.alpha = 0
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.4, animations: {
                self.birdLabelHorizontalAlign.constant = -self.view.frame.width * 2 / 3
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                completion()
            })
        })
    }
    
    final func showAccountVerifyingUI() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.verifyingLabel.alpha = 1
            self.activityIndicator.alpha = 1
        }
    }
}
