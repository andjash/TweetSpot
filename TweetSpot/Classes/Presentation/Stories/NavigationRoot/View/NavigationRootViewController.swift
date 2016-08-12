//
//  NavigationRootNavigationRootViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class NavigationRootViewController: UIViewController  {

    var output: NavigationRootViewOutput!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var birdLabel: UILabel!
    @IBOutlet weak var birdLabelHorizontalAlign: NSLayoutConstraint!
    @IBOutlet weak var verifyingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    @IBOutlet weak var gradientView: UIView!
    
    weak var gradientLayer: CAGradientLayer!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ts_applicationPrimaryColor
        self.verifyingLabel.text = "root_verifying_account".ts_localized("Root")
        
        let gLayer = CAGradientLayer.ts_applicationPrimaryGradient
        gradientView.layer.addSublayer(gLayer)
        gradientLayer = gLayer
        output.viewIsReady()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        output.viewIsAppeared()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        verifyingLabel.alpha = 0
        activityIndicator.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = gradientView.bounds
    }

}

extension NavigationRootViewController : NavigationRootViewInput {
    func setupInitialState() {
        
    }
    
    func showAppLaunchAnimation(completion: () -> ()) {
        UIView.animateWithDuration(0.5, animations: {
            self.gradientView.alpha = 1
            self.titleLabel.alpha = 0
        }) { (completed) in
            UIView.animateWithDuration(0.4, animations: {
                self.birdLabelHorizontalAlign.constant = -self.view.frame.width * 2 / 3
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                    completion()
            })
        }
    }
    
    func showAccountVerifyingUI() {
        activityIndicator.startAnimating()
        UIView.animateWithDuration(0.3) {
            self.verifyingLabel.alpha = 1
            self.activityIndicator.alpha = 1
        }
    }
}
