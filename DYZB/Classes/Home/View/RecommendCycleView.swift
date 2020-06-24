//
//  RecommendCycleView.swift
//  DYZB
//
//  Created by Andy on 2020/6/21.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit
private let kCycleCellID = "kCycleCellID"

class RecommendCycleView: UIView {
    //定义属性
    var cycleTimer: Timer?

    var cycleModels : [CycleModel]? {
        didSet{
            CycleCollectionView.reloadData()

            //设置pagecontrol个数
            CyclePageControl.numberOfPages = cycleModels?.count ?? 0

            //默认滚动到中间位置
            let indexPath = NSIndexPath(item: (cycleModels?.count ?? 0) * 10, section:0)
            CycleCollectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)

            //添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }

    //控件
    @IBOutlet weak var CycleCollectionView: UICollectionView!
    @IBOutlet weak var CyclePageControl: UIPageControl!

    //系统回掉
    override func awakeFromNib() {
        super.awakeFromNib()
        // 让控件不随着父控件的拉伸而拉伸
        //autoresizingMask = UIViewAutoresizing()
        // 注册Cell
        CycleCollectionView.register(UINib(nibName: "CollectionCycleCell", bundle:nil ), forCellWithReuseIdentifier: kCycleCellID)


    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //设置collectionCiew的layout
        let layout = CycleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CycleCollectionView.bounds.size
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        CycleCollectionView.isPagingEnabled = true
    }
}


//提供一个快速创建View的类方法
extension RecommendCycleView {
    class func recommendCycleView() -> RecommendCycleView {
         return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
}


//遵守UiCollectionView数据源协议
extension RecommendCycleView : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
        cell.cycleModel = cycleModels![indexPath.item % cycleModels!.count]


        return cell
    }


}

//
extension RecommendCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //1.获取滚动偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5

        //2.计算pagecontrol的currentIndex
        CyclePageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}


//对定时器的操作方法
extension RecommendCycleView {
    private func addCycleTimer() {
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoop.Mode.common)

    }

    func removeCycleTimer() {
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }

    @objc func scrollToNext() {
        // 1.获取滚动的偏移量
       let currentOffsetX = CycleCollectionView.contentOffset.x
       let offsetX = currentOffsetX + CycleCollectionView.bounds.width

       // 2.滚动该位置
       CycleCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
