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

extension LoginPresenter : LoginViewOutput{
    
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
    
    func choosenAccount(name: String?) {
        if let username = name {
            interactor.loginWithChoosenAccount(username)
        } else {
            view.displayProgres(enabled: false, completion: {                 
            })
        }
    }
}

extension LoginPresenter : LoginInteractorOutput {
    
    func loginSuccess() {
        router.closeModule()
    }
    
    func loginFailed(error: NSError) {
        view.displayProgres(enabled: false) {
            self.view.displayError(error)
        }
    }
    
    func chooseFromLocalAccountsWithNames(names: [String]) {
        self.view.displayAccountChooser(names)
    }
    
    

}
