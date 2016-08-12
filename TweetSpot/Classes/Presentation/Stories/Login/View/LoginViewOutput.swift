//
//  LoginLoginViewOutput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol LoginViewOutput {

    /**
        @author Andrey Yashnev
        Notify presenter that view is ready
    */

    func viewIsReady()
    func viewDidAppear()
    func loginTapped(login: String?, password: String?)
}
