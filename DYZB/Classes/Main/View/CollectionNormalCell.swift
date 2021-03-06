//
//  CollectionNormalCell.swift
//  DYZB
//
//  Created by Andy on 2020/6/18.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {
    //控件属性
    @IBOutlet weak var roomNameLabel: UILabel!

    //定义模型属性
   override var anchor : AnchorModel? {
        didSet{
            super.anchor = anchor
            //房间名字
            roomNameLabel.text = anchor?.room_name
        }
    }
}
