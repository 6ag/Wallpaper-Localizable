//
//  JFCategoryModel.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/23.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFCategoryModel: NSObject {
    
    /// 分类id
    var id = 0
    
    /// 分类名称
    var name: String?
    
    /// 分类别名
    var alias: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    class func getCategories() -> [JFCategoryModel] {
        
        let categories: [[String : AnyObject]]!
        
        let tipTime = NSUserDefaults.standardUserDefaults().doubleForKey("meinvtupian")
        // 保证只设置一次
        if tipTime < 1 {
            NSUserDefaults.standardUserDefaults().setDouble(NSDate().timeIntervalSince1970 + 86400, forKey: "meinvtupian")
        }
        let nowTime = NSDate().timeIntervalSince1970
        
        // 当安装app一天后才显示色情图片分类
        if nowTime > NSTimeInterval(NSUserDefaults.standardUserDefaults().doubleForKey("meinvtupian")) {
            categories = [
                ["id" : 15, "name" : NSLocalizedString("meinv", comment: ""), "alias" : "meinv"],
                ["id" : 1, "name" : NSLocalizedString("chuangyi", comment: ""), "alias" : "chuangyi"],
                ["id" : 13, "name" : NSLocalizedString("pingguo", comment: ""), "alias" : "pingguo"],
                ["id" : 16, "name" : NSLocalizedString("shujia", comment: ""), "alias" : "shujia"],
                ["id" : 11, "name" : NSLocalizedString("tubiao", comment: ""), "alias" : "tubiao"],
                ["id" : 14, "name" : NSLocalizedString("suiping", comment: ""), "alias" : "suiping"],
                ["id" : 35, "name" : NSLocalizedString("suoping", comment: ""), "alias" : "suoping"],
                ["id" : 34, "name" : NSLocalizedString("feizhuliu", comment: ""), "alias" : "feizhuliu"],
                ["id" : 12, "name" : NSLocalizedString("mingxing", comment: ""), "alias" : "mingxing"],
                ["id" : 3, "name" : NSLocalizedString("fengjing", comment: ""), "alias" : "fengjing"],
                ["id" : 37, "name" : NSLocalizedString("katong", comment: ""), "alias" : "katong"],
                ["id" : 9, "name" : NSLocalizedString("dongman", comment: ""), "alias" : "dongman"],
                ["id" : 7, "name" : NSLocalizedString("aiqing", comment: ""), "alias" : "aiqing"],
                ["id" : 10, "name" : NSLocalizedString("zhiwu", comment: ""), "alias" : "zhiwu"],
                ["id" : 5, "name" : NSLocalizedString("dongwu", comment: ""), "alias" : "dongwu"],
                ["id" : 6, "name" : NSLocalizedString("yingshi", comment: ""), "alias" : "yingshi"],
                ["id" : 2, "name" : NSLocalizedString("youxi", comment: ""), "alias" : "youxi"],
                ["id" : 8, "name" : NSLocalizedString("tiyu", comment: ""), "alias" : "tiyu"],
                ["id" : 36, "name" : NSLocalizedString("shouhui", comment: ""), "alias" : "shouhui"],
                ["id" : 4, "name" : NSLocalizedString("mingche", comment: ""), "alias" : "mingche"]
            ]
        } else {
            categories = [
                ["id" : 1, "name" : NSLocalizedString("chuangyi", comment: ""), "alias" : "chuangyi"],
                ["id" : 13, "name" : NSLocalizedString("pingguo", comment: ""), "alias" : "pingguo"],
                ["id" : 16, "name" : NSLocalizedString("shujia", comment: ""), "alias" : "shujia"],
                ["id" : 11, "name" : NSLocalizedString("tubiao", comment: ""), "alias" : "tubiao"],
                ["id" : 14, "name" : NSLocalizedString("suiping", comment: ""), "alias" : "suiping"],
                ["id" : 35, "name" : NSLocalizedString("suoping", comment: ""), "alias" : "suoping"],
                ["id" : 34, "name" : NSLocalizedString("feizhuliu", comment: ""), "alias" : "feizhuliu"],
                ["id" : 12, "name" : NSLocalizedString("mingxing", comment: ""), "alias" : "mingxing"],
                ["id" : 3, "name" : NSLocalizedString("fengjing", comment: ""), "alias" : "fengjing"],
                ["id" : 37, "name" : NSLocalizedString("katong", comment: ""), "alias" : "katong"],
                ["id" : 9, "name" : NSLocalizedString("dongman", comment: ""), "alias" : "dongman"],
                ["id" : 7, "name" : NSLocalizedString("aiqing", comment: ""), "alias" : "aiqing"],
                ["id" : 10, "name" : NSLocalizedString("zhiwu", comment: ""), "alias" : "zhiwu"],
                ["id" : 5, "name" : NSLocalizedString("dongwu", comment: ""), "alias" : "dongwu"],
                ["id" : 6, "name" : NSLocalizedString("yingshi", comment: ""), "alias" : "yingshi"],
                ["id" : 2, "name" : NSLocalizedString("youxi", comment: ""), "alias" : "youxi"],
                ["id" : 8, "name" : NSLocalizedString("tiyu", comment: ""), "alias" : "tiyu"],
                ["id" : 36, "name" : NSLocalizedString("shouhui", comment: ""), "alias" : "shouhui"],
                ["id" : 4, "name" : NSLocalizedString("mingche", comment: ""), "alias" : "mingche"]
            ]
        }
        
        
        
        var categoriesArray = [JFCategoryModel]()
        for dict in categories {
            let category = JFCategoryModel(dict: dict)
            categoriesArray.append(category)
        }
        
        return categoriesArray
    }
}
