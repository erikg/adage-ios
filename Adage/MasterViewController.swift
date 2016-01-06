//
//  MasterViewController.swift
//  Adage
//
// Created by Erik Greenwald on 7/8/15.
//
// Adage-iOS - iOS interface to the adage api at http://elfga.com/adage
// Copyright (c) 2015 ElfGA Software Solutions, LLC
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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl();
        if(self.refreshControl != nil ) {
            self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh");
            self.refreshControl!.addTarget(self, action: "update:", forControlEvents: UIControlEvents.ValueChanged);
            self.tableView.addSubview(refreshControl!);
        }
        update();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = Fortunes.sharedInstance.setCurrent(indexPath.row)
            (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fortunes.sharedInstance.count()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = Fortunes.sharedInstance.at(indexPath.row)
        cell.textLabel!.text = object.title()
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
//            Fortunes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
*/

    // MARK: - App funcs

    func update() {
        /*
        let urlstring = NSString(format: "http://elfga.com/adage/raw/") as String;
        if let data = NSData(contentsOfURL: NSURL(string: urlstring)!) {
            if let json = (try? NSJSONSerialization.JSONObjectWithData(data,options:[])) as? NSArray {
 //               Fortunes.removeAll();
                self.tableView.reloadData();
                for entry in json {
                    let id = entry["id"] as? Int;
                    let db = entry["db"] as? String;
                    let shortbody = entry["body"] as? String;

//                    Fortunes.append(Fortune(db:db!,id:id!,shortbody:shortbody!));
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
*/
        for _ in Fortunes.sharedInstance.all() {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        self.tableView.reloadData();
    }

    func update(sender: AnyObject) {
        update();
        self.refreshControl?.endRefreshing();
    }
}

