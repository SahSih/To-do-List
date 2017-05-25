//
//  Events.swift
//  ToDoList
//
//  Created by Chris Peng on 3/11/17.
//  Copyright © 2017 Chris Peng. All rights reserved.
//

import UIKit

class Event: NSObject {

    var text: String?
    var detail: String?
    var timestamp: NSNumber?

    init(dictionary: [String: AnyObject]) {
        super.init()

        text = dictionary["title"] as? String
        detail = dictionary["detail"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
    }

}
