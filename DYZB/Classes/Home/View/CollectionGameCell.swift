//
//  CollectionGameCell.swift
//  DYZB
//
//  Created by Andy on 2020/6/22.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

class CollectionGameCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var group : AnchorGroup? {
        didSet{
            titleLabel.text = group?.tag_name
            let iconURL = URL(string: group?.icon_url ?? "")
            iconImageView.kf.setImage(with: iconURL,placeholder: UIImage(named: "home_more_btn"))
        }
    }

}
