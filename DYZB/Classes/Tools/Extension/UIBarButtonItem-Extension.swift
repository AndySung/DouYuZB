//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by Andy on 2020/6/17.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    /*class func createItem(imageName: String, highImageName: String) -> UIBarButtonItem {
        let size = CGSize(width: 40, height: 40)
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)

        btn.frame = CGRect(origin: CGPoint.zero, size: size)

        return UIBarButtonItem(customView: btn)
    }*/

    //便利构造函数： 1. 以convenience开头
    //2. 在构造函数中必须明确调用一个设计的构造函数
    convenience init(imageName: String = "", highImageName: String = "",size: CGSize = CGSize.zero){
        //创建UIButton
        let btn = UIButton()

        //设置btn图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != ""{
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }

        if size == CGSize.zero{
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        self.init(customView: btn)
    }
}
