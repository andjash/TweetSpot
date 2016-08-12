//
//  LoginLoginPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class LoginPresenter: NSObject, LoginModuleInput, LoginInteractorOutput {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!


}

extension LoginPresenter : LoginViewOutput{
    
    func viewDidAppear() {
        view.focusLoginField()
    }
    
    func viewIsReady() {
    }
    
    func loginTapped(login: String?, password: String?) {
        
        view.showLoginProgress(enabled: true) { [unowned self] in
            
        }
    }
}
