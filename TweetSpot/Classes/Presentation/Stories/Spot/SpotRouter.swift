//
//  SpotSpotRouter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

final class SpotRouter: NSObject {

	final weak var sourceController: UIViewController!

    // MARK: - Inout
    
    final func closeModule() {
        sourceController.ts_closeController(animated: true)
    }
    
    final func routeToSettingsModule() {
        sourceController.performSegue(withIdentifier: "SpotToSettingsSegue", sender: nil)
    }
    
    final func routeToTweetDetails(_ withDTO: AnyObject) {
        sourceController.ts_openController(TweetDetailsViewController.self, storyboardId: "SpotToTweetDetailsSegue") { (c) in
            c.output.configureWithDTO(withDTO)
        }
    }

}
