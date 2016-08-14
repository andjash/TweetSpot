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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIBarButtonItem!    
    
    var sections: [SettingsSection]?
    var switchToItemMapping: [UISwitch : SettingsItem]?
    
    private static let switchAssociationKey = "SettingsViewController.SwitchToSettingsItem"
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.ts_applicationPrimaryColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        title = "settings_title".ts_localized("Settings")
        closeButton.title = "common_close".ts_localized("Common")
        tableView.tableFooterView = UIView()
        output.viewIsReady()
    }

    // MARK: Actions
    
    @IBAction func closeAction(sender: AnyObject?) {
        output.closeRequested()
    }
    
    
    // MARK Private
    
    func switchChanged(sender: AnyObject?) {
        if let swtch = sender as? SettingsSwitch,
               item = swtch.associatedItem {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.output.selectedItem(item)
            }
        }
    }

    // MARK: SettingsViewInput
    func setupInitialState() {
    }
    
    func showSettings(sections: [SettingsSection]) {
        self.sections = sections
        tableView.reloadData()
    }
}


extension SettingsViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as! SettingsCell
        let item = sections![indexPath.section].items[indexPath.row]
        cell.settingTitleLabel.text = item.name
        if let item = item as? SwitchSettingsItem {
            cell.valueSwitch.on = item.value
        }
        cell.selectionStyle = .None
        cell.valueSwitch.associatedItem = item
        cell.valueSwitch.addTarget(self, action: #selector(SettingsViewController.switchChanged), forControlEvents: .ValueChanged)
        return cell
    }
}

extension SettingsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SettingsCell.cellHeight(withItem: sections![indexPath.section].items[indexPath.row], tableWidth: tableView.frame.width)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section].name ?? ""
    }
}

