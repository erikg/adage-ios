//
//  Fortunes.swift
//  Adage
//
//  Created by Erik Greenwald on 10/21/15.
//  Copyright © 2015-2016 ElfGA. All rights reserved.
//

import Foundation

class Fortunes {
    static let sharedInstance = Fortunes()
    var fortune_list = [Fortune]();
    var index = 0;
    let urlstring = NSString(format: "http://elfga.com/adage/raw/") as String;
    let prefetch = 2;

    init() {
        var new_fortunes = []
        if let data = NSData(contentsOfURL: NSURL(string: urlstring)!) {
            if let json = (try? NSJSONSerialization.JSONObjectWithData(data,options:[])) as? NSArray {
                new_fortunes = self.parse_array(json)
            }
        }
        self.fortune_list = new_fortunes as! [Fortune]
    }

    func parse_array(json: NSArray) -> [Fortune] {
        var out = [Fortune]()
        for entry in json {
            let id = entry["id"] as? Int;
            let db = entry["db"] as? String;
            let shortbody = entry["body"] as? String;
            
            out.append(Fortune(db:db!,id:id!,shortbody:shortbody!));
        }

        return out
    }

    func fetch_previous() {
        var new_fortunes: [Fortune]?
        if let data = NSData(contentsOfURL: NSURL(string: urlstring)!) {
            if let json = (try? NSJSONSerialization.JSONObjectWithData(data,options:[])) as? NSArray {
                index += json.count;
                new_fortunes = parse_array(json);
            }
        }
        fortune_list = new_fortunes! + fortune_list
    }

    func fetch_next() {
        var new_fortunes: [Fortune]?
        if let data = NSData(contentsOfURL: NSURL(string: urlstring)!) {
            if let json = (try? NSJSONSerialization.JSONObjectWithData(data,options:[])) as? NSArray {
                new_fortunes = parse_array(json)
            }
        }
        fortune_list = fortune_list + new_fortunes!
    }

    func current() -> Fortune {
        return fortune_list[index];
    }

    func next() -> Fortune {
        if(index > fortune_list.count - prefetch) {
            fetch_next();
        }
        fortune_list[index+1].fetch();
        fortune_list[index+2].fetch();
        return fortune_list[++index];
    }

    func previous() -> Fortune {
        index--;
        if(index < prefetch) {
            fetch_previous();
        }
        fortune_list[index-0].fetch();
        fortune_list[index-1].fetch();
        return fortune_list[index];
    }

    func all() -> [Fortune] {
        return fortune_list;
    }

    func count() -> Int {
        return fortune_list.count;
    }

    func at(var val: Int) -> Fortune {
        if(val > fortune_list.count - prefetch) {
            fetch_next();
        }
        if(val < prefetch) {
            fetch_previous();
            val = 20 + val;
        }
        fortune_list[val+1].fetch();
        fortune_list[val+2].fetch();
        fortune_list[val-1].fetch();
        fortune_list[val-2].fetch();
        return fortune_list[val];
    }

    func setCurrent(val: Int) -> Fortune {
        index = val;
        if(index > fortune_list.count - prefetch) {
            fetch_next();
            fortune_list[index+1].fetch();
            fortune_list[index+2].fetch();
        }
        if(index < -prefetch) {
            fetch_previous();
            fortune_list[index-1].fetch();
            fortune_list[index-2].fetch();
        }
        return current()
    }

}
