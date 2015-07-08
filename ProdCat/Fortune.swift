//
//  Fortune.swift
//  ProdCat
//
//  Created by Erik Greenwald on 7/8/15.
//  Copyright (c) 2015 ElfGA. All rights reserved.
//

import Foundation


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