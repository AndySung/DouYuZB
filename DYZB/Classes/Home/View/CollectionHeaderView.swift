//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by Andy on 2020/6/18.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!

     @IBOutlet weak var moreBtn: UIButton!

    @IBOutlet weak var iconImageView: UIImageView!
    //定义模型属性
    var group : AnchorGroup? {
        didSet{
            titleLabel.text = group?.tag_name
            iconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }

}


// MARK:- 从Xib中快速创建的类方法
extension CollectionHeaderView {
    class func collectionHeaderView() -> CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
}
