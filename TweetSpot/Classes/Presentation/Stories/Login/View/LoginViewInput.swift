//
//  LoginLoginViewInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol LoginViewInput {

    /**
        @author Andrey Yashnev
        Setup initial state of the view
    */

    func setupInitialState()
    func displayProgres(enabled: Bool, completion: @escaping () -> ())
    func displayError(_ error: NSError)
    func displayAccountChooser(_ accounts: [String])
}
