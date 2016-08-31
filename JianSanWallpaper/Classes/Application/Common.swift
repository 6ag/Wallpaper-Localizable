//
//  Common.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import MJRefresh

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
let SCREEN_BOUNDS = UIScreen.mainScreen().bounds

/**
 拉方式
 
 - pullUp:   上拉
 - pullDown: 下拉
 */
enum PullMethod {
    case pullUp
    case pullDown
}

/**
 快速创建上拉加载更多控件
 */
func jf_setupFooterRefresh(target: AnyObject, action: Selector) -> MJRefreshAutoNormalFooter {
    let footerRefresh = MJRefreshAutoNormalFooter(refreshingTarget: target, refreshingAction: action)
    footerRefresh.automaticallyHidden = true
    footerRefresh.setTitle(NSLocalizedString("pullUpRefreshingTip", comment: ""), forState: MJRefreshState.Refreshing)
    footerRefresh.setTitle(NSLocalizedString("pullUpIdleTip", comment: ""), forState: MJRefreshState.Idle)
    footerRefresh.setTitle(NSLocalizedString("pullUpNoMoreDataTip", comment: ""), forState: MJRefreshState.NoMoreData)
    return footerRefresh
}

/**
 快速创建下拉加载最新控件
 */
func jf_setupHeaderRefresh(target: AnyObject, action: Selector) -> MJRefreshNormalHeader {
    let headerRefresh = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: action)
    headerRefresh.lastUpdatedTimeLabel.hidden = true
    headerRefresh.stateLabel.hidden = true
    return headerRefresh
}

/// 导航背景颜色
let NAVBAR_TINT_COLOR = UIColor.whiteColor()

/// 标题颜色
let TITLE_COLOR = UIColor(red: 142 / 255.0, green: 120 / 255.0, blue: 152 / 255.0, alpha: 1.0)

/// 标题字体
let TITLE_FONT = UIFont.systemFontOfSize(17)

/// 控制器背景颜色
let BACKGROUND_COLOR = UIColor(red:0.933,  green:0.933,  blue:0.933, alpha:1)

/// 全局边距
let MARGIN: CGFloat = 12

/// 全局圆角
let CORNER_RADIUS: CGFloat = 5

/// 应用id
let APPLE_ID = "1147917306"

/// 插页广告id
let INTERSTITIAL_UNIT_ID = "ca-app-pub-3941303619697740/6565296910"

/// 横幅广告id
let BANNER_UNIT_ID = "ca-app-pub-3941303619697740/2135097318"