//
//  HomeViewController.swift
//  DYZB
//
//  Created by Andy on 2020/6/17.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

private let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    //懒加载属性
    private lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: (kNavigationBarH + kNavigationBarH ), width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()


    private lazy var pageContentView: PageContentView = {[weak self] in
       //确定内容的frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kNavigationBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)

        //确定所有的子控制器
        var childVcs = [UIViewController]()
        childVcs.append(ReconmmendViewController())
        for _ in 0..<3{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }

        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()

    //系统回掉函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

}

//MARK: 设置UI界面
extension HomeViewController {
    private func setupUI(){
        //不需要调整UIScrollview 类边距
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
        view.addSubview(pageTitleView)

        view.addSubview(pageContentView)

        pageContentView.backgroundColor = UIColor.purple
    }

    private func setupNavigationBar() {
        //设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")

        let size = CGSize(width: 40, height: 40)
        //设置右侧的Item
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "image_my_history_click",size: size)

        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked",size: size)

        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click",size: size)

        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]


    }
}


//遵守PageTitleViewDelegate协议
extension HomeViewController: PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}


//遵守PageContentViewDelegate协议
extension HomeViewController: PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceInde: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceInde, targetIndex: targetIndex)
    }
}
