//
//  JFWallPaperModel.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/26.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import SwiftyJSON
import YYWebImage

class JFWallPaperModel: NSObject {
    
    /// 壁纸id
    var ID: Int = 0
    
    /// 图片名称 带后缀
    var PicName: String?
    
    /// 大分类id
    var BigCategoryId = 0
    
    /// 大分类名称
    var PicCategoryName: String?
    
    /// 壁纸下载路径
    var WallPaperDownloadPath: String?
    
    /// 大图路径
    var WallPaperBig: String?
    
    /// 中图路径
    var WallPaperMiddle: String?
    
    /// 小图路径
    var WallPaperFlow: String?
    
    // 快速构造模型
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /**
     缓存大图
     
     - parameter bigpath: 大图路径
     */
    private class func bigImageCache(bigpath: String) {
        
        // 延迟是为了优先缓存缩略图
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            if !YYImageCache.sharedCache().containsImageForKey(bigpath) {
                YYWebImageManager(cache: YYImageCache.sharedCache(), queue: NSOperationQueue()).requestImageWithURL(NSURL(string: bigpath)!, options: YYWebImageOptions.UseNSURLCache, progress: { (_, _) in
                    }, transform: { (image, url) -> UIImage? in
                        return image
                    }, completion: { (image, url, type, stage, error) in
                })
            }
        }
    }
    
    /**
     从网络请求壁纸数据列表
     
     - parameter category_id: 壁纸分类id
     - parameter page:        分页页码
     - parameter finished:    数据回调
     */
    class func loadWallpapersFromNetwork(category_id: Int, page: Int, finished: (wallpaperArray: [JFWallPaperModel]?, error: NSError?) -> ()) {
        
        JFNetworkTools.shareNetworkTools.get("http://j2.24kidea.com/Wallpaper/WallpaperNewAll-1-\(category_id)-0-\(page)-30.html", parameters: nil) { (success, result, error) in
            
            guard let result = result where success == true else {
                finished(wallpaperArray: nil, error: error)
                return
            }
            
            var wallpaperArray = [JFWallPaperModel]()
            let data = result["WallpaperListInfo"].arrayObject as! [[String : AnyObject]]
            for dict in data {
                let wallpaper = JFWallPaperModel(dict: dict)
                self.bigImageCache(wallpaper.WallPaperBig!)
                wallpaperArray.append(wallpaper)
            }
            
            finished(wallpaperArray: wallpaperArray, error: nil)
        }
        
        
    }
    
}
