//
//  SettingsSettingsViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var output: SettingsPresenter!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIBarButtonItem!    
    
    var sections: [SettingsSection]?
    var switchToItemMapping: [UISwitch : SettingsItem]?
    
    fileprivate static let switchAssociationKey = "SettingsViewController.SwitchToSettingsItem"
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.ts_applicationPrimaryColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        title = "settings_title".ts_localized("Settings")
        closeButton.title = "common_close".ts_localized("Common")
        tableView.tableFooterView = UIView()
        output.viewIsReady()
    }

    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: AnyObject?) {
        output.closeRequested()
    }
    
    
    // MARK: - Private
    
    @objc func switchChanged(_ sender: AnyObject?) {
        if let swtch = sender as? SettingsSwitch,
               let item = swtch.associatedItem {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                self.output.selectedItem(item)
            }
        }
    }

    // MARK: View input

    func showSettings(_ sections: [SettingsSection]) {
        self.sections = sections
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource protocol
extension SettingsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        let item = sections![indexPath.section].items[indexPath.row]
        cell.settingTitleLabel.text = item.name
        if let item = item as? SwitchSettingsItem {
            cell.valueSwitch.isOn = item.value
        }
        cell.selectionStyle = .none
        cell.valueSwitch.associatedItem = item
        cell.valueSwitch.addTarget(self, action: #selector(SettingsViewController.switchChanged), for: .valueChanged)
        return cell
    }
}

// MARK: - UITableViewDelegate protocol

extension SettingsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsCell.cellHeight(withItem: sections![indexPath.section].items[indexPath.row], tableWidth: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section].name ?? ""
    }
}

