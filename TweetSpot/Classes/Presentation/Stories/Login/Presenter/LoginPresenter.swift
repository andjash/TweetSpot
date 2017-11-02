//
//  LoginLoginPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class LoginPresenter: NSObject, LoginModuleInput {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!


}

// MARK: LoginViewOutput protocol
extension LoginPresenter : LoginViewOutput {
    
    func viewIsReady() {
    }
    
    func loginWithIosAccountTapped() {
        view.displayProgres(enabled: true) {
            self.interactor.loginWithIOSAccountRequested()
        }
    }
    
    func loginWithPasswordTapped() {
        view.displayProgres(enabled: true) {
            self.interactor.loginWithPasswordRequested()
        }
    }
    
    func choosenAccount(_ name: String?) {
        if let username = name {
            interactor.loginWithChoosenAccount(username)
        } else {
            view.displayProgres(enabled: false, completion: {                 
            })
        }
    }
}

// MARK: LoginInteractorOutput protocol
extension LoginPresenter : LoginInteractorOutput {
    
    func loginSuccess() {
        router.closeModule()
    }
    
    func loginFailed(_ error: NSError) {
        view.displayProgres(enabled: false) {
            self.view.displayError(error)
        }
    }
    
    func chooseFromLocalAccountsWithNames(_ names: [String]) {
        self.view.displayAccountChooser(names)
    }
    
    

}
