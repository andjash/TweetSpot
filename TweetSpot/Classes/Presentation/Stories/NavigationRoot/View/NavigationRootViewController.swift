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
    
    @IBOutlet weak var gradientView: UIView!
    
    
    weak var gradientLayer: CAGradientLayer!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ts_applicationPrimaryColor
        
        let gLayer = CAGradientLayer()
        gLayer.colors = [UIColor.ts_applicationSecondaryColor, UIColor.ts_applicationPrimaryColor.CGColor]
        gLayer.locations = [0.0 , 1.0]
        gLayer.startPoint = CGPoint(x: 0, y: 0)
        gLayer.endPoint = CGPoint(x: 0, y: 2)
        gradientView.layer.addSublayer(gLayer)
        gradientLayer = gLayer
        output.viewIsReady()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        output.viewIsAppeared()
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
        UIView.animateWithDuration(0.3, animations: { 
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
}