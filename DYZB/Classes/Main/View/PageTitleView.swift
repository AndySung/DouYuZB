//
//  PageTitleView.swift
//  DYZB
//
//  Created by Andy on 2020/6/17.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}



private let kScrollLineH: CGFloat = 2
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    //定义属性
    private var currentIndex: Int = 0
    private var titles: [String]
    weak var delegate: PageTitleViewDelegate?
    
    //懒加载
    private lazy var titleLabels: [UILabel] = [UILabel]()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()

    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()

    //MARK 自定义构造函数
    init(frame: CGRect, titles: [String]){
        self.titles = titles
        super.init(frame: frame)
        //设置UI界面
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// 设置UI界面
extension PageTitleView {
    private func setupUI(){
        addSubview(scrollView)
        scrollView.frame = bounds

        //添加title对应的Label
        setupTitleLabels()

        //设置底线和滚动滑块
        setupBottomLineAndScrollLine()
    }

    private func setupTitleLabels(){
        //确定label的一些frame 的值
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH
        let labelY: CGFloat = 0

        for (index, title) in titles.enumerated() {
            //创建Label
            let label = UILabel()

            //设置Label样式
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center

            //设置Label的Frame
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)

            //将label添加到scrollview中
            scrollView.addSubview(label)
            titleLabels.append(label)

            //给label 添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }

    private func setupBottomLineAndScrollLine(){
        //添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: lineH)
        addSubview(bottomLine)

        //添加scrollLine
        //获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height  - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }

}

//监听label 的点击
extension PageTitleView {
   @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {


        //获取当前label下标值
        guard let currentLabel = tapGes.view as? UILabel else { return }
        //如果重复点击同一个title那么直接返回
        if currentLabel.tag == currentIndex { return }

        //获取之前label
        let oldLabel = titleLabels[currentIndex]

        //切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor =  UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)

        //保存最新label下标值
        currentIndex = currentLabel.tag

        //滚动条位置发生改变
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
            UIView.animate(withDuration: 0.15, animations: {
            self.scrollLine.frame.origin.x = scrollLineX
        })

        //通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
   }
}


//MARK: 对外暴露的方法   ==注释==
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]

        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX

        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)

        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)

        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)

        // 4.记录最新的index
        currentIndex = targetIndex
    }
}
