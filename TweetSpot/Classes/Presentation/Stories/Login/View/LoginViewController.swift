//
//  LoginLoginViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var output: LoginViewOutput!
    
    @IBOutlet weak var loginWithIOSButton: UIButton!
    @IBOutlet weak var loginWithPasswordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
 
    weak var gradientLayer: CAGradientLayer!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginWithIOSButton.setTitle("login_with_ios_button_title".ts_localized("Login"), forState: .Normal)
        loginWithPasswordButton.setTitle("login_with_pass_button_title".ts_localized("Login"), forState: .Normal)
        

        let gLayer = CAGradientLayer.ts_applicationPrimaryGradient
        view.layer.addSublayer(gLayer)
        gradientLayer = gLayer
        output.viewIsReady()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }

    // MARK: Actions
    
    @IBAction func enterWithIOSAccountAction(sender: AnyObject?) {
        output.loginWithIosAccountTapped()
    }

    @IBAction func enterWithPasswordAction(sender: AnyObject?) {
        output.loginWithPasswordTapped()
    }
}

extension LoginViewController : LoginViewInput {
    
    func setupInitialState() {
    }
    
    func displayProgres(enabled enabled: Bool, completion: () -> ()) {
        if enabled {
            UIView.animateWithDuration(0.3, animations: {
                self.loginWithIOSButton.alpha = 0
                self.loginWithPasswordButton.alpha = 0
            }) { (completed) in
                self.activityIndicator.startAnimating()
                UIView.animateWithDuration(0.3, animations: {
                    self.activityIndicator.alpha = 1
                    }, completion: { (completed) in
                        completion()
                })
            }
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.activityIndicator.alpha = 0
            }) { (completed) in
                self.activityIndicator.stopAnimating()
                UIView.animateWithDuration(0.3, animations: {
                    self.loginWithIOSButton.alpha = 1
                    self.loginWithPasswordButton.alpha = 1
                    }, completion: { (completed) in
                        completion()
                })
            }
        }
        
    }
}


