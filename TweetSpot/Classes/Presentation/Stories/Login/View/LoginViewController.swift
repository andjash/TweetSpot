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
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var keyboardPlaceholderHeight: NSLayoutConstraint!
    
    weak var gradientLayer: CAGradientLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        subscribeToKeyboardNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.setTitle("login_enter_button_title".ts_localized("Login"), forState: .Normal)
        loginTextField.attributedPlaceholder = NSAttributedString(string: "login_login_field_placeholder".ts_localized("Login"),
                                                                  attributes: [NSForegroundColorAttributeName : UIColor.lightTextColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "login_password_field_placeholder".ts_localized("Login"),
                                                                  attributes: [NSForegroundColorAttributeName : UIColor.lightTextColor()])

        let gLayer = CAGradientLayer.ts_applicationPrimaryGradient
        view.layer.addSublayer(gLayer)
        gradientLayer = gLayer
        output.viewIsReady()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }

    
    // MARK: Private
    
    private func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShowNotification(_:)),
                                                         name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHideNotification(_:)),
                                                         name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue ?? 0.3
        UIView.animateWithDuration(duration, animations: {
            let height = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 220
            self.keyboardPlaceholderHeight.constant = height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue ?? 0.3
        UIView.animateWithDuration(duration, animations: {
            self.keyboardPlaceholderHeight.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: Actions
    
    @IBAction func loginAction(sender: AnyObject?) {
        output.loginTapped(loginTextField.text, password: passwordTextField.text)
    }
    
}

extension LoginViewController : LoginViewInput {
    
    func setupInitialState() {
    }
    
    func focusLoginField() {
        loginTextField.becomeFirstResponder()
    }
    
    func showLoginProgress(enabled enabled: Bool, completion: () -> ()) {
        if enabled {
            loginTextField.enabled = false
            passwordTextField.enabled = false
            UIView.animateWithDuration(0.15, animations: {
                self.loginButton.alpha = 0
            }) { (completed) in
                self.activityIndicator.startAnimating()
                UIView.animateWithDuration(0.15, animations: {
                    self.activityIndicator.alpha = 1
                }, completion: { (completed) in
                    completion()
                })
            }
        } else {
            UIView.animateWithDuration(0.15, animations: {
                self.activityIndicator.alpha = 0
            }) { (completed) in
                self.activityIndicator.stopAnimating()
                UIView.animateWithDuration(0.15, animations: {
                    self.loginButton.alpha = 1
                    }, completion: { (completed) in
                        self.loginTextField.enabled = true
                        self.passwordTextField.enabled = true
                        completion()
                })
            }
        }
    }
}


extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            output.loginTapped(loginTextField.text, password: passwordTextField.text)
        }
        return true
    }
    
}
