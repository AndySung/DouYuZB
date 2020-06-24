//
//  CollectionBaseCellCollectionViewCell.swift
//  DYZB
//
//  Created by Andy on 2020/6/21.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    //控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!


    //定义模型
    var anchor: AnchorModel? {
        didSet{
                //0.校验模型是否有值
                guard let anchor = anchor else {return}
                //1.取出在线人数显示文字
                var onlineStr : String = ""
                if anchor.online >= 10000 {
                    onlineStr = "\(Int(anchor.online / 10000))万在线"
                }else {
                    onlineStr = "\(anchor.online)在线"
                }
                onlineBtn.setTitle(onlineStr, for: .normal)

                //2.昵称
                nickNameLabel.text = anchor.nickname


                //3.设置封面图片
              guard let iconURL =  URL(string: anchor.vertical_src) else {return}
                iconImageView.kf.setImage(with: iconURL)
            }
        }
}
