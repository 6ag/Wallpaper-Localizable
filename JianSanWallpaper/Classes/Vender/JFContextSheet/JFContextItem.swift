//
//  JFContextItem.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/22.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFContextItem: UIView {
    
    // MARK: - 初始化
    init(itemName: String, itemIcon: String) {
        super.init(frame: CGRect(origin: CGPointZero, size: CGSize(width: 40, height: 50)))
        
        itemLabel.text = itemName
        itemImage.image = UIImage(named: itemIcon)
        
        
        let itemWidth = (itemName as NSString).boundingRectWithSize(CGSizeMake(CGFloat.max, 16), options: [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading], attributes: [NSFontAttributeName : itemLabel.font], context: nil).size.width
        itemLabel.frame = CGRect(x: 0, y: 0, width: itemWidth + 10, height: 16)
        itemImage.frame = CGRect(x: (itemWidth + 10) * 0.5 - 12.5, y: 15, width: 25, height: 35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    lazy var itemLabel: UILabel = {
        let itemLabel = UILabel()
        itemLabel.textColor = UIColor.whiteColor()
        itemLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        itemLabel.layer.cornerRadius = 8
        itemLabel.layer.masksToBounds = true
        itemLabel.textAlignment = NSTextAlignment.Center
        itemLabel.font = UIFont.systemFontOfSize(10)
        self.addSubview(itemLabel)
        return itemLabel
    }()
    
    lazy var itemImage: UIImageView = {
        let itemImage = UIImageView()
        itemImage.contentMode = .ScaleAspectFit
        self.addSubview(itemImage)
        return itemImage
    }()
    
}
