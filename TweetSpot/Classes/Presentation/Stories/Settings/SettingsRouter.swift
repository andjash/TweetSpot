//
//  SettingsSettingsRouter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class SettingsRouter: NSObject {

	final weak var sourceController: UIViewController!

    // MARK: - Inout
    
    final func closeModule() {
        sourceController.ts_closeController(animated: true)
    }
    
}
