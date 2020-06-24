//
//  NSDate-Extension.swift
//  DYZB
//
//  Created by Andy on 2020/6/19.
//  Copyright © 2020 Andy. All rights reserved.
//

import Foundation


extension NSDate {
    class func getCurrentTime() -> String {
        let nowDate = NSDate()

        let interval = Int(nowDate.timeIntervalSince1970)

        return "\(interval)"
    }
}
