//
//  BaseGameModel.swift
//  DYZB
//
//  Created by Andy on 2020/6/21.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

class BaseGameModel: NSObject {
    // MARK:- 定义属性
       var tag_name : String = ""
       var icon_url : String = ""

       // MARK:- 自定义构造函数
       override init() {

       }

       init(dict : [String : Any]) {
           super.init()

           setValuesForKeys(dict)
       }

       override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
