//
//  PageContentView.swift
//  DYZB
//
//  Created by Andy on 2020/6/17.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    func pageContentView(contentView : PageContentView, progress: CGFloat, sourceInde: Int, targetIndex: Int)
}
private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    //定义属性
    private var childVcs: [UIViewController]
    private weak var parentViewController: UIViewController?
    private var startOfsetX: CGFloat = 0
    private var isForbidScrollDelegate: Bool = false

    weak var delegate: PageContentViewDelegate?

    //懒加载
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal

        //创建UiColletionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
    }()

    //自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)

        //设置UI界面
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// 设置UI界面

extension PageContentView {
    private func setupUI(){
        //将所有子控制器添加到父控制器
        for childVc in childVcs {
            parentViewController?.addChild(childVc)
        }

        //添加UICollectionView，用于在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        //给Cell 设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }

        let childVc = childVcs[(indexPath as NSIndexPath).item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)

        return cell
    }
}


//遵守UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false

        startOfsetX = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // 0.判断是否是点击事件
        if isForbidScrollDelegate { return }

        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0

        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOfsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)

            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)

            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }

            // 4.如果完全划过去
            if currentOffsetX - startOfsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))

            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)

            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }

        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceInde: sourceIndex, targetIndex: targetIndex)
    }
}

//对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex: Int){
        //记录需要进行执行代理方法
        isForbidScrollDelegate = true
        //滚到正确位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
