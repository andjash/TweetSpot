//
//  CommonTableDataManager.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

import UIKit

protocol CommonTableDataManagerDelegate: class {
    func dataItemSelected(_ item: AnyObject)
}

protocol CommonTableDataManager: class, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: CommonTableDataManagerDelegate? {get set}
    func attach(to tableView: UITableView)
    func reload(with data: [AnyObject])
}