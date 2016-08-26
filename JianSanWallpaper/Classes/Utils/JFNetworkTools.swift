//
//  JFNetworkTools.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class JFNetworkTools: NSObject {
    
    /// 网络请求回调闭包 success:是否成功  flag:预留参数  result:字典数据 error:错误信息
    typealias NetworkFinished = (success: Bool, result: JSON?, error: NSError?) -> ()
    static let shareNetworkTools = JFNetworkTools()
}

extension JFNetworkTools {
    
    /**
     get请求
     
     - parameter URLString:  接口url
     - parameter parameters: 参数
     - parameter finished:   回调
     */
    func get(URLString: String, parameters: [String : AnyObject]?, finished: NetworkFinished) {
        
        Alamofire.request(.GET, URLString, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            guard let data = response.data else {
                finished(success: false, result: nil, error: response.result.error)
                return
            }
            
            let json = JSON(data: data)
            finished(success: true, result: json, error: nil)
        }
    }
    
    /**
     post请求
     
     - parameter URLString:  接口url
     - parameter parameters: 参数
     - parameter finished:   回调
     */
    func post(URLString: String, parameters: [String : AnyObject]?, finished: NetworkFinished) {
        
        Alamofire.request(.POST, URLString, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            
            guard let data = response.data else {
                finished(success: false, result: nil, error: response.result.error)
                return
            }
            
            // 解析json数据
            let json = JSON(data: data)
            
            // 判断是否请求成功
            if (json["meta"]["status"].stringValue == "success") {
                finished(success: true, result: json, error: nil)
            } else {
                finished(success: false, result: json, error: response.result.error)
            }
        }
    }
    
}