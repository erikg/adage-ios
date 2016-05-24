//
//  Fortune.swift
//  Adage
//
// Created by Erik Greenwald on 7/8/15.
//
// Adage-iOS - iOS interface to the adage api at http://elfga.com/adage
// Copyright (c) 2015-2016 ElfGA Software Solutions, LLC
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

import Foundation

public class Fortune {
    var db: String;
    var id: Int;
    var shortbody: String;
    var body: String?;
    var fetching: Bool;

    init(db:String, id:Int, shortbody:String) {
        self.db = db;
        self.id = id;
        self.shortbody = shortbody;
        self.body = nil;
        self.fetching = false;
    }

    func parseJson(data: NSData) {
        let json = (try! NSJSONSerialization.JSONObjectWithData(data,options:[])) as! NSDictionary;
        body = json["body"] as? String;
    }

    func fetch(uri: String) {
        if(body != nil || fetching) {
            return;
        }
        fetching = true;
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: uri)!),
            queue: NSOperationQueue(),
            completionHandler: {(response:NSURLResponse?, responseData:NSData?, error: NSError?) -> Void in
                self.fetching = false;
                if error == nil {
                    self.parseJson(responseData!);
                } else {
                    NSLog("Unable to fetch from \(uri): \(error!.domain)")
                }
            });
    }

    func fetch() {
        fetch(NSString(format: "http://elfga.com/adage/raw/%@/%d", db, id) as String);
    }

    func getBody() -> String? {
        if( body != nil ) {
            return body;
        }
        if( fetching == false ) {
            fetch(NSString(format: "http://elfga.com/adage/raw/%@/%d", db, id) as String);
        }
        /* spinlock until value is returned */
        while(fetching == true) {
            sleep(0);
        }

        return body;
    }

    func title() -> String {
        return db + "/" + id.description + ": " + shortbody;
    }

}
