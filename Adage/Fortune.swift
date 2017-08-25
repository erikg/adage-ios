//
//  Fortune.swift
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

import Foundation

open class Fortune {
    var db: String
    var id: Int
    var shortbody: String
    var body: String?
    var fetching: Bool

    init(db:String, id:Int, shortbody:String) {
        self.db = db
        self.id = id
        self.shortbody = shortbody
        self.body = nil
        self.fetching = false
    }

    init(json:[String:AnyObject]) {
        self.db = json["db"] as? String ?? "BAD DB"
        self.id = json["id"] as? Int ?? -1
        self.shortbody = json["body"] as? String ?? "BAD BODY"
        self.body = nil
        self.fetching = false
    }

    func parseJson(_ data: Data) {
        let json = (try! JSONSerialization.jsonObject(with: data,options:[])) as! NSDictionary
        body = json["body"] as? String
    }

    func fetch(_ uri: String) {
        if(body != nil || fetching) {
            return
        }
        fetching = true
        NSURLConnection.sendAsynchronousRequest(URLRequest(url: URL(string: uri)!),
            queue: OperationQueue(),
            completionHandler: {(response:URLResponse?, responseData:Data?, error: Error?) -> Void in
                self.fetching = false
                if error == nil {
                    self.parseJson(responseData!)
                } else {
                    NSLog("Unable to fetch from \(uri): \(String(describing: error))")
                }
            })
    }

    func fetch() {
        fetch(NSString(format: "http://elfga.com/adage/raw/%@/%d", db, id) as String)
    }

    func getBody() -> String? {
        if( body != nil ) {
            return body
        }
        if( fetching == false ) {
            fetch(NSString(format: "http://elfga.com/adage/raw/%@/%d", db, id) as String)
        }
        /* spinlock until value is returned */
        while(fetching == true) {
            sleep(0)
        }

        return body
    }

    func title() -> String {
        return db + "/" + id.description + ": " + shortbody
    }

}
