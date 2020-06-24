//
//  RecommendViewModel.swift
//  DYZB
//
//  Created by Andy on 2020/6/19.
//  Copyright © 2020 Andy. All rights reserved.
//

import UIKit
class RecommendViewModel : BaseViewModel {
    //懒加载属性
    //lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
      lazy var cycleModels : [CycleModel] = [CycleModel]()

    private lazy var bigDataGroup: AnchorGroup = AnchorGroup()

    private lazy var PrettyGroup: AnchorGroup = AnchorGroup()

}


//发送网络请求
extension RecommendViewModel {
    func requestData(_ finishCallback : @escaping () -> ()) {
        // 0. 定义参数
        let parameters = ["limit": "4", "offset": "0", "time" : NSDate.getCurrentTime()]

        // 创建Group
        let dGroup = DispatchGroup()

        // 3.请求第一部分推荐数据
        dGroup.enter()

        //1. 请求第一部分推荐数据(http://capi.douyucdn.cn/api/v1/getbigDataRoom)
        //http://capi.douyucdn.cn/api/v1/getbigDataRoom?time=1592547027
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time": NSDate.getCurrentTime()]) { (result) in
            //1.将result 转成字典类型
           guard let resultDict = result as? [NSString: NSObject] else { return }

           //根据data 该key获取数组
           guard let dataArray = resultDict["data"] as? [[String: NSObject]] else { return }

            //3.遍历字典，并转为模型对象
            //3.2 设置组属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            //3.3 获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)

            }

            // 3.3.离开组
            dGroup.leave()
            print("all data 00000")
        }


        //2. 请求第二部分颜值数据(http://capi.douyucdn.cn/api/v1/getVerticalRoom)
        //http://capi.douyucdn.cn/api/v1/getVerticalRoom?limit=4&offset=0&time=1592547027
        dGroup.enter()
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom",parameters: parameters) { (result) in
            //1.将result 转成字典类型
            guard let resultDict = result as? [NSString : NSObject] else { return }

            //根据data 该key获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }

            //3.遍历字典，并转为模型对象
            //3.2 设置组属性
            self.PrettyGroup.tag_name = "颜值"
            self.PrettyGroup.icon_name = "home_header_phone"
            //3.3 获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.PrettyGroup.anchors.append(anchor)

            }

            // 3.3.离开组
            dGroup.leave()
             print("all data 1111")
        }

        //3. 请求2-12部分游戏数据
        // http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1592547027
        dGroup.enter()
//        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
//            //1.将result 转成字典类型
//            guard let resultDict = result as? [NSString: NSObject] else { return }
//
//            //根据data 该key获取数组
//            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else { return }
//
//            //遍历数组，获取字典，并且讲字典转成模型对象
//            for dict in dataArray {
//                let group = AnchorGroup(dict: dict)
//                print("******6666666***\(group.anchors)")
//                self.anchorGroups.append(group)
//
//            }
//
//            for group in self.anchorGroups {
//                print("******545555***\(self.anchorGroups[0].anchors.count)")
//                for anchor in group.anchors {
//                    print(anchor.nickname)
//                     print("******00000000***")
//                }
//            }
//
//            dGroup.leave()
//             print("all data 2-12")
//        }

        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) {
            dGroup.leave()
        }


        // 6.所有的数据都请求到,之后进行排序
        dGroup.notify(queue: DispatchQueue.main) {
            print("all data douzai")
            self.anchorGroups.insert(self.PrettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            finishCallback()
        }
    }

    //请求无限轮播的数据
    func requestCycleData(_ finishCallback : @escaping () -> ()) {
        NetworkTools.requestData(.get, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.300"]) { (result) in
            //获取字典数据
            guard let resultDict = result as? [String : NSObject] else { return }
            //根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            //字典转模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict: dict))
            }
            finishCallback()
        }
    }
}
