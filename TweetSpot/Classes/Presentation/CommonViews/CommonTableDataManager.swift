//
//  CommonTableDataManager.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

import UIKit

@objc protocol CommonTableDataManagerDelegate {
    func dataItemSelected(_ item: AnyObject)
}

@objc protocol CommonTableDataManager: UITableViewDataSource, UITableViewDelegate {
    weak var delegate: CommonTableDataManagerDelegate? {get set}
    func attachTo(_ tableView: UITableView)
    func reloadWithData(_ data: [AnyObject])
}


