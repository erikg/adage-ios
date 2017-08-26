//
//  MasterViewController.swift
//  Adage
//
// Created by Erik Greenwald on 7/8/15.
//
// Adage-iOS - iOS interface to the adage api at http://elfga.com/adage
// Copyright (c) 2015-2017 ElfGA Software Solutions, LLC
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
// import Foundation

import UIKit


class MasterViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        if(self.refreshControl != nil ) {
            self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refreshControl!.addTarget(self, action: #selector(MasterViewController.update(_:)), for: UIControlEvents.valueChanged)
            self.tableView.addSubview(refreshControl!)
        }
        NotificationCenter.default.addObserver(forName: Notification.update, object: nil, queue: nil) {
            notification in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = Fortunes.sharedInstance.setCurrent(indexPath.row)
                (segue.destination as! DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fortunes.sharedInstance.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = Fortunes.sharedInstance.at(indexPath.row)
        cell.textLabel!.text = object.title
        return cell
    }

    // MARK: - App funcs
    func update(_ sender: AnyObject?) {
        Fortunes.sharedInstance.update { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
}
