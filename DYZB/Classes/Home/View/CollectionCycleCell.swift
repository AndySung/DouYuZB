//
//  CollectionCycleCell.swift
//  DYZB
//
//  Created by Andy on 2020/6/21.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

class CollectionCycleCell: UICollectionViewCell {

    //kongjian

    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    var cycleModel: CycleModel? {
        didSet{
            titleLabel.text = cycleModel?.title
//            let iconURL = URL(string: cycleModel?.pic_url ?? "Img_default")!
            guard let iconURL =  URL(string: cycleModel?.pic_url ?? "Img_default") else {return}
            print("URL:\(iconURL)")
            iconImageView.kf.setImage(with: iconURL)

//            guard let iconURL =  URL(string: anchor.vertical_src) else {return}
//                          iconImageView.kf.setImage(with: iconURL)
        }
    }

}
