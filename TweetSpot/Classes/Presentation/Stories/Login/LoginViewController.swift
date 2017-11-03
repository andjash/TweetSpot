//
//  LoginLoginViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    var output: LoginPresenter!
    
    @IBOutlet weak var loginWithIOSButton: UIButton!
    @IBOutlet weak var loginWithPasswordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var gradientLayer: CAGradientLayer!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginWithIOSButton.setTitle("login_with_ios_button_title".ts_localized("Login"), for: UIControlState())
        loginWithPasswordButton.setTitle("login_with_pass_button_title".ts_localized("Login"), for: UIControlState())
        

        let gLayer = CAGradientLayer.ts_applicationPrimaryGradient
        view.layer.addSublayer(gLayer)
        gradientLayer = gLayer
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }

    // MARK: - View input
    
    final func displayProgres(enabled: Bool, completion: @escaping () -> ()) {
        if enabled {
            UIView.animate(withDuration: 0.3, animations: {
                self.loginWithIOSButton.alpha = 0
                self.loginWithPasswordButton.alpha = 0
            }, completion: { (completed) in
                self.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.3, animations: {
                    self.activityIndicator.alpha = 1
                }, completion: { (completed) in
                    completion()
                })
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.activityIndicator.alpha = 0
            }, completion: { (completed) in
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.3, animations: {
                    self.loginWithIOSButton.alpha = 1
                    self.loginWithPasswordButton.alpha = 1
                }, completion: { (completed) in
                    completion()
                })
            })
        }
    }
    
    final func displayError(_ error: NSError) {
        let alert = UIAlertController(title: "common_error".ts_localized("Common"), message: error.ts_userFriendlyDescription, preferredStyle: .alert)
        let okActinon = UIAlertAction(title: "common_ok".ts_localized("Common"), style: .cancel, handler: nil)
        alert.addAction(okActinon)
        self.present(alert, animated: true, completion: nil)
    }
    
    final func displayAccountChooser(_ accounts: [String]) {
        let alert = UIAlertController(title: "login_account_chooser_title".ts_localized("Login"), message: nil, preferredStyle: .actionSheet)
        
        for name in accounts {
            let action = UIAlertAction(title: name, style: .default, handler: {(action) in
                self.output.choosenAccount(name)
            })
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "common_cancel".ts_localized("Common"), style: .cancel, handler: {(action) in
            self.output.choosenAccount(nil)
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func enterWithIOSAccountAction(_ sender: AnyObject?) {
        output.loginWithIosAccountTapped()
    }

    @IBAction func enterWithPasswordAction(_ sender: AnyObject?) {
        output.loginWithPasswordTapped()
    }
    
}
