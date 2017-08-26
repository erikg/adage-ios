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

typealias NetCompletion = (_ response:URLResponse?, _ responseData:Data?, _ error:Error?) -> Void

public class Fortune {
    private var db: String
    private var id: Int
    private var shortbody: String
    private var body: String?
    private var fetching: Bool

    public var title:String {
        get {
            return db + "/" + id.description + ": " + shortbody
        }
    }

    private var completionHandlers = [NetCompletion?]()

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
        let json = (try! JSONSerialization.jsonObject(with: data,options:[])) as! [String:AnyObject]
        body = json["body"] as? String
    }

    func fetch(_ uri: String, _ completionHandler:NetCompletion?) {
        if body != nil {
            completionHandler?(nil,nil,nil)
            return
        }
        if let ch = completionHandler {
            completionHandlers.append(ch)
        }
        if fetching { return }
        fetching = true
        NSURLConnection.sendAsynchronousRequest(URLRequest(url: URL(string: uri)!), queue: OperationQueue(), completionHandler: {
            response, responseData, error in
            if error == nil && responseData != nil { self.parseJson(responseData!) }
            self.fetching = false   // might be worth locking this and the next couple bits with a mutex or something
            self.completionHandlers.forEach {
                $0?(response, responseData, error)
            }
            self.completionHandlers.removeAll()
        })
    }

    func fetch() {
        fetch(nil)
    }

    func fetch(_ completionHandler:NetCompletion?) {
        fetch(String(format: "http://elfga.com/adage/raw/%@/%d", db, id), completionHandler)
    }
    
    func getBody() -> String? {
        return body
    }
}
