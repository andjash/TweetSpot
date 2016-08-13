//
//  SettingsSettingsViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewInput {

    var output: SettingsViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        title = "settings_title".ts_localized("Settings")
        output.viewIsReady()
    }


    // MARK: SettingsViewInput
    func setupInitialState() {
    }
}
