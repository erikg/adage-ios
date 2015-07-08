//
//  Fortune.swift
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


public class Fortune {
    var db: String;
    var id: Int;
    var shortbody: String;
    var body: String?;

    init(db:String, id:Int, shortbody:String) {
        self.db = db;
        self.id = id;
        self.shortbody = shortbody;
        self.body = nil;
    }

    func getBody() -> String? {
        if( body != nil ) {
            return body;
        }
        var urlstring = NSString(format: "http://elfga.com/adage/raw/%@/%d", db, id) as String;
        var data = NSData(contentsOfURL: NSURL(string: urlstring)!);
        var datastr = NSString(data: data!, encoding:NSUTF8StringEncoding) as! String;

        var json = NSJSONSerialization.JSONObjectWithData(data!,options:nil,error:nil) as! NSDictionary;
        body = json["body"] as? String;

        return body;
    }

    func title() -> String {
        return db + "/" + id.description + ": " + shortbody;
    }

}
