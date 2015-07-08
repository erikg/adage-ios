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

    var Fortunes = [Fortune]();


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        update();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = Fortunes[indexPath.row]
            (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fortunes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = Fortunes[indexPath.row]
        cell.textLabel!.text = object.title()
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            Fortunes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // MARK: - App funcs

    func update() {
        var urlstring = NSString(format: "http://elfga.com/adage/raw/") as String;
        var data = NSData(contentsOfURL: NSURL(string: urlstring)!);
        var datastr = NSString(data: data!, encoding:NSUTF8StringEncoding) as! String;

        var json = NSJSONSerialization.JSONObjectWithData(data!,options:nil,error:nil) as? NSArray;
        var items = json! as NSArray;
        Fortunes.removeAll(keepCapacity: true);
        for entry in items {
            var id = entry["id"] as? Int;
            var db = entry["db"] as? String;
            var shortbody = entry["body"] as? String;

            Fortunes.append(Fortune(db:db!,id:id!,shortbody:shortbody!));
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
}

