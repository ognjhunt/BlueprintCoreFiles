//
//  StatsTableViewController.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 12/6/22.
//

import UIKit

class StatsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .light
        self.navigationController?.title = "Stats"
        self.tableView.register(UserEarningsTableViewCell.self, forCellReuseIdentifier: "userEarningsCell")
        self.tableView.register(AccountBalanceTableViewCell.self, forCellReuseIdentifier: "accountBalanceCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userEarningsCell", for: indexPath)
            tableView.rowHeight = 198
            return cell
        }
        
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountBalanceCell", for: indexPath)
            tableView.rowHeight = 80
            return cell
        }

         return UITableViewCell()
    }
}
