//
//  CollectionPrettyCell.swift
//  DYZB
//
//  Created by Andy on 2020/6/18.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionPrettyCell: CollectionBaseCell {
    //控件属性
    @IBOutlet weak var cityBtn: UIButton!
    //定义模型属性
   override var anchor : AnchorModel? {
        didSet{
            super.anchor = anchor
            //3.所在城市
            cityBtn.setTitle(anchor?.anchor_city, for: .normal)
        }
    }

}
