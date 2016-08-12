//
//  SpotSpotViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController, SpotViewInput {

    var output: SpotViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: SpotViewInput
    func setupInitialState() {
    }
    
    // MARK: Action
    
    @IBAction func quitAction(sender: AnyObject?) {
        output.quitRequested()
    }
}
