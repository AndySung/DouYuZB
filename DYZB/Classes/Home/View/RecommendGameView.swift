//
//  RecommendGameView.swift
//  DYZB
//
//  Created by Andy on 2020/6/22.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit
private let kGameCellID = "kGameCellID"
let kEdgeInsetMargin: CGFloat = 10
class RecommendGameView: UIView {

    var groups: [AnchorGroup]? {
        didSet{
            // 1.移除前两组数据
            groups?.removeFirst()
            groups?.removeFirst()

            //2.添加更多
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups?.append(moreGroup)
            collctionView.reloadData()
        }
    }

    @IBOutlet weak var collctionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //让控件不随着父控件拉伸而拉伸
        autoresizingMask = .init()

        //注册Cell
         collctionView.register(UINib(nibName: "CollectionGameCell", bundle:nil ), forCellWithReuseIdentifier: kGameCellID)

        //给collectionView添加内边距
        collctionView.contentInset = UIEdgeInsets(top: 0, left: kEdgeInsetMargin, bottom: 0, right: kEdgeInsetMargin)

    }

}

extension RecommendGameView {
    class func recommendGameView() -> RecommendGameView {
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
}


extension RecommendGameView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell

        cell.group = groups![indexPath.item]
        
        return cell
    }


}
