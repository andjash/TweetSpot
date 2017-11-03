//
//  LoginLoginPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

final class LoginPresenter {

    final weak var view: LoginViewController!
    final var interactor: LoginInteractor!
    final var router: LoginRouter!
    
    // MARK: - View output

    final func loginWithIosAccountTapped() {
        view.displayProgres(enabled: true) {
            self.interactor.loginWithIOSAccountRequested()
        }
    }
    
    final func loginWithPasswordTapped() {
        view.displayProgres(enabled: true) {
            self.interactor.loginWithPasswordRequested()
        }
    }
    
    final func choosenAccount(_ name: String?) {
        if let username = name {
            interactor.loginWithChoosenAccount(username)
        } else {
            view.displayProgres(enabled: false) {}
        }
    }
    
    // MARK: - Interactor output
    
    final func loginSuccess() {
        router.closeModule()
    }
    
    final func loginFailed(_ error: Error) {
        view.displayProgres(enabled: false) {
            self.view.displayError(error)
        }
    }
    
    final func chooseFromLocalAccountsWithNames(_ names: [String]) {
        self.view.displayAccountChooser(names)
    }
    
}
