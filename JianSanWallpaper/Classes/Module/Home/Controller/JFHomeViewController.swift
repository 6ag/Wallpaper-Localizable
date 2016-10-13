//
//  JFHomeViewController.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/26.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage
import SnapKit
import Firebase
import GoogleMobileAds

class JFHomeViewController: UIViewController {
    
    /// 横坐标偏移量
    var contentOffsetX: CGFloat = 0.0
    
    /// 分类模型数组
    let categories = JFCategoryModel.getCategories()
    
    // MARK: - 视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 准备视图
        prepareUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showAppstoreTip()
    }
    
    /**
     弹出提示让用户去评论
     */
    private func showAppstoreTip() {
        
        // 在当前时间往后的1天后提示
        let tipTime = NSUserDefaults.standardUserDefaults().doubleForKey("tipToAppstore")
        
        // 设置第一次弹出提示的时间
        if tipTime < 1 {
            NSUserDefaults.standardUserDefaults().setDouble(NSDate().timeIntervalSince1970 + 86400, forKey: "tipToAppstore")
        }
        
        // 当前时间超过了规定时间就弹出提示
        let nowTime = NSDate().timeIntervalSince1970
        if nowTime > NSTimeInterval(NSUserDefaults.standardUserDefaults().doubleForKey("tipToAppstore")) {
            let appstore = LBToAppStore()
            appstore.myAppID = APPLE_ID
            appstore.showGotoAppStore(self)
        }
        
    }
    
    // MARK: - 各种自定义方法
    /**
     准备视图
     */
    private func prepareUI() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(leftButton)
        view.addSubview(topScrollView)
        view.addSubview(contentScrollView)
        
        // 添加内容
        addContent()
    }
    
    /**
     添加顶部标题栏和控制器
     */
    private func addContent() {
        
        // 布局用的左边距
        var leftMargin: CGFloat = 0
        
        for i in 0..<categories.count {
            
            let label = JFTopLabel()
            label.text = categories[i].name!
            label.tag = i
            label.scale = i == 0 ? 1.0 : 0.0
            label.userInteractionEnabled = true
            topScrollView.addSubview(label)
            
            // 利用layout来自适应各种长度的label
            label.snp_makeConstraints(closure: { (make) -> Void in
                make.left.equalTo(leftMargin + 15)
                make.centerY.equalTo(topScrollView)
            })
            
            // 更新布局和左边距
            topScrollView.layoutIfNeeded()
            leftMargin = CGRectGetMaxX(label.frame)
            
            // 添加标签点击手势
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedTopLabel(_:))))
            
            // 添加控制器
            let newsVc = JFPopularViewController()
            addChildViewController(newsVc)
            
            // 默认控制器
            if i <= 1 {
                addContentViewController(i)
            }
        }
        
        // 内容区域滚动范围
        contentScrollView.contentSize = CGSize(width: CGFloat(childViewControllers.count) * SCREEN_WIDTH, height: 0)
        contentScrollView.pagingEnabled = true
        
        let lastLabel = topScrollView.subviews.last as! JFTopLabel
        // 设置顶部标签区域滚动范围
        topScrollView.contentSize = CGSize(width: leftMargin + lastLabel.frame.width, height: 0)
        
        // 视图滚动到第一个位置
        contentScrollView.setContentOffset(CGPoint(x: 0, y: contentScrollView.contentOffset.y), animated: true)
    }
    
    /**
     添加内容控制器
     
     - parameter index: 控制器角标
     */
    private func addContentViewController(index: Int) {
        
        // 获取需要展示的控制器
        let newsVc = childViewControllers[index] as! JFPopularViewController
        
        // 如果已经展示则直接返回
        if newsVc.view.superview != nil {
            return
        }
        
        newsVc.view.frame = CGRect(x: CGFloat(index) * SCREEN_WIDTH, y: 0, width: contentScrollView.bounds.width, height: contentScrollView.bounds.height)
        contentScrollView.addSubview(newsVc.view)
        newsVc.category_id = categories[index].id
    }
    
    /**
     顶部标签的点击事件
     */
    @objc private func didTappedTopLabel(gesture: UITapGestureRecognizer) {
        let titleLabel = gesture.view as! JFTopLabel
        contentScrollView.setContentOffset(CGPoint(x: CGFloat(titleLabel.tag) * contentScrollView.frame.size.width, y: contentScrollView.contentOffset.y), animated: true)
    }
    
    /**
     点击了左边导航按钮
     */
    func didTappedLeftBarButton() {
        UIView.animateWithDuration(0.25) {
            self.sideView.show()
        }
    }
    
    // MARK: - 懒加载
    /// 导航栏左边按钮
    lazy var leftButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "cehua_icon"), forState: .Normal)
        button.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
        button.addTarget(self, action: #selector(didTappedLeftBarButton), forControlEvents: .TouchUpInside)
        return button
    }()
    
    /// 侧边栏
    private lazy var sideView: JFSideView = {
        let sideView = JFSideView.makeSideView()
        sideView.delegate = self
        return sideView
    }()
    
    /// 顶部标签按钮区域
    lazy var topScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 44, y: 20, width: SCREEN_WIDTH - 44, height: 44))
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    /// 内容区域
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        scrollView.delegate = self
        return scrollView
    }()
    
}

// MARK: - scrollView代理方法
extension JFHomeViewController: UIScrollViewDelegate {
    
    // 滚动结束后触发 代码导致
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        // 滚动标题栏
        let titleLabel = topScrollView.subviews[index]
        var offsetX = titleLabel.center.x - topScrollView.frame.size.width * 0.5
        let offsetMax = topScrollView.contentSize.width - topScrollView.frame.size.width
        
        if offsetX < 0 {
            offsetX = 0
        } else if (offsetX > offsetMax) {
            offsetX = offsetMax
        }
        
        // 滚动顶部标题
        topScrollView.setContentOffset(CGPoint(x: offsetX, y: topScrollView.contentOffset.y), animated: true)
        
        // 恢复其他label缩放
        for i in 0..<categories.count {
            if i != index {
                let topLabel = topScrollView.subviews[i] as! JFTopLabel
                topLabel.scale = 0.0
            }
        }
        
        // 添加控制器 - 并预加载控制器  左滑预加载下下个 右滑预加载上上个 保证滑动流畅
        let value = (scrollView.contentOffset.x / scrollView.frame.width)
        
        var index1 = Int(value)
        var index2 = Int(value)
        
        // 根据滑动方向计算下标
        if scrollView.contentOffset.x - contentOffsetX > 2.0 {
            index1 = (value - CGFloat(Int(value))) > 0 ? Int(value) + 1 : Int(value)
            index2 = index1 + 1
        } else if contentOffsetX - scrollView.contentOffset.x > 2.0 {
            index1 = (value - CGFloat(Int(value))) < 0 ? Int(value) - 1 : Int(value)
            index2 = index1 - 1
        }
        
        // 控制器角标范围
        if index1 > childViewControllers.count - 1 {
            index1 = childViewControllers.count - 1
        } else if index1 < 0 {
            index1 = 0
        }
        if index2 > childViewControllers.count - 1 {
            index2 = childViewControllers.count - 1
        } else if index2 < 0 {
            index2 = 0
        }
        
        addContentViewController(index1)
        addContentViewController(index2)
    }
    
    // 滚动结束 手势导致
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    // 开始拖拽视图
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        contentOffsetX = scrollView.contentOffset.x
    }
    
    // 正在滚动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let value = (scrollView.contentOffset.x / scrollView.frame.width)
        
        let leftIndex = Int(value)
        let rightIndex = leftIndex + 1
        let scaleRight = value - CGFloat(leftIndex)
        let scaleLeft = 1 - scaleRight
        
        let labelLeft = topScrollView.subviews[leftIndex] as! JFTopLabel
        labelLeft.scale = scaleLeft
        
        if rightIndex < topScrollView.subviews.count {
            if let labelRight = topScrollView.subviews[rightIndex] as? JFTopLabel {
                labelRight.scale = scaleRight
            }
        }
    }
    
}

// MARK: - JFHomeTopViewDelegate
extension JFHomeViewController: JFSideViewDelegate {
    
    /**
     我的收藏
     */
    func didTappedMyCollectionButton() {
        navigationController?.pushViewController(JFCollectionViewController(), animated: true)
    }
    
    /**
     清理缓存
     */
    func didTappedCleanCacheButton() {
        
        let cache = "\(String(format: "%.2f", CGFloat(YYImageCache.sharedCache().diskCache.totalCost()) / 1024 / 1024))M"
        
        let alertController = UIAlertController(title: "\(cache) " + NSLocalizedString("Cache", comment: ""), message: NSLocalizedString("cleanupTip", comment: ""), preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel) { (action) in
        }
        let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: UIAlertActionStyle.Destructive) { (action) in
            JFProgressHUD.showWithStatus(NSLocalizedString("StartCleanup", comment: ""))
            JFFMDBManager.sharedManager.removeAllStarWallpapaer()
            YYImageCache.sharedCache().diskCache.removeAllObjectsWithBlock({
                JFProgressHUD.showSuccessWithStatus(NSLocalizedString("successTip", comment: ""))
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        presentViewController(alertController, animated: true) {}
        
    }
    
    /**
     意见反馈
     */
    func didTappedFeedbackButton() {
        navigationController?.pushViewController(JFFeedbackViewController(), animated: true)
    }
}

