//
//  LoginLoginRouter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class LoginRouter: NSObject {

    final weak var sourceController: UIViewController!
    
    // MARK: - Input
    
    final func closeModule() {
        sourceController.ts_closeController(animated: true)
    }
}
