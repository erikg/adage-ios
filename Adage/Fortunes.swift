//
//  Fortunes.swift
//  Adage
//
//  Created by Erik Greenwald on 10/21/15.
//  Copyright © 2015-2017 ElfGA. All rights reserved.
//

import Foundation

class Fortunes {
    static let sharedInstance = Fortunes()
    var fortune_list = [Fortune]() {
        didSet {
            NotificationCenter.default.post(name: Notification.update, object: self)
        }
    }
    var index = 0
    let urlstring = NSString(format: "http://elfga.com/adage/raw/") as String
    let prefetch = 2

    func parse_array(_ json: [[String:AnyObject]]) -> [Fortune] {
        return json.map { Fortune(json:$0) }
    }

    func fetch_previous() {
        if let data = try? Data(contentsOf: URL(string: urlstring)!),
            let json = (try? JSONSerialization.jsonObject(with: data,options:[])) as? [[String:AnyObject]] {
            index += json.count
            EGLog("cnt: \(json.count)   idx: \(index)")
            fortune_list = parse_array(json) + fortune_list
        }
    }

    func fetch_next() {
        if let data = try? Data(contentsOf: URL(string: urlstring)!),
            let json = (try? JSONSerialization.jsonObject(with: data,options:[])) as? [[String:AnyObject]] {
            fortune_list = fortune_list + parse_array(json)
            EGLog("cnt: \(json.count)   idx: \(index)")
        }
    }

    func update(_ completionHandler:((_ res:Bool) -> Void)? = nil) {
        if let data = try? Data(contentsOf: URL(string: urlstring)!) {
            if let json = (try? JSONSerialization.jsonObject(with: data,options:[])) as? [[String:AnyObject]] {
                fortune_list = self.parse_array(json)
                EGLog("cnt: \(json.count)   idx: \(index)")
                completionHandler?(true)
            }
        }
    }

    func safeFetch(_ index:Int) {
        if index >= 0 && index < fortune_list.count {
            fortune_list[index].fetch()
        } else {
            NSLog("Bad index access: \(index)/\(fortune_list.count)")
        }
    }
    
    func current() -> Fortune {
        return fortune_list[index]
    }

    func next() -> Fortune {
        if(index > fortune_list.count - prefetch) {
            fetch_next()
        }
        index += 1
        self.safeFetch(index)
        self.safeFetch(index + 1)
        return fortune_list[index]
    }

    func previous() -> Fortune {
        if(index < prefetch) {
            fetch_previous()
        }
        index -= 1
        self.safeFetch(index)
        self.safeFetch(index - 1)
        return fortune_list[index]
    }

    func all() -> [Fortune] {
        return fortune_list
    }

    func count() -> Int {
        return fortune_list.count
    }

    func at(_ val: Int) -> Fortune {
        fortune_list[val].fetch()
        return fortune_list[val]
    }

    func setCurrent(_ val: Int) -> Fortune {
        index = val
        return current()
    }

}
