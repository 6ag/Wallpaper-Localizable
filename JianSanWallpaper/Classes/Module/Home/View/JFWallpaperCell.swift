//
//  JFWallpaperCell.swift
//  JianSanWallpaper
//
//  Created by zhoujianfeng on 16/7/25.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage

class JFWallpaperCell: UICollectionViewCell {
    
    var model: JFWallPaperModel? {
        didSet {
            wallpaperImageView.yy_setImageWithURL(NSURL(string: model!.WallPaperFlow!), placeholder: UIImage(named: "placeholder"), options: YYWebImageOptions.Progressive, completion: nil)
        }
    }
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
}
