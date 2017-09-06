//
//  IPService.swift
//  JSCore-IPQuery-Demo
//
//  Created by 梁宪松 on 2017/9/6.
//  Copyright © 2017年 Madao. All rights reserved.
//

import UIKit
import JavaScriptCore

let API = "http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip="

class IPService: NSObject {

    lazy var jsContext : JSContext? = {
        
        let context = JSContext()
        
        // 1 获取 basic.js 文档路径
        guard let basicJSPath = Bundle.main.path(forResource: "basic", ofType: "js")             else {
                print("Unable to read resource files.")
                return nil
        }
        
        // 2 加载 basic.js 文件 并执行
        do {
            let basic = try String(contentsOfFile: basicJSPath, encoding: String.Encoding.utf8)
            
            _ = context?.evaluateScript(basic)
            
            // 将IPInfo对象暴露给JS
            context?.setObject(IPInfo.self, forKeyedSubscript: "IPInfo" as (NSCopying & NSObjectProtocol)!)
            
        } catch (let error) {
            print("Error while processing script file: \(error)")
        }
        
        return context
    }()
    
    // 获取IPInfo
    func fetchIpInfo(ip:String, complete: @escaping (IPInfo) -> ()) {
        
        guard let url = URL(string:API + ip)  else {
            
            print("Invalid url format: \(API + ip)")
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, _, _ in
            
            
            guard let tempData = data, let dataString = String.init(data: tempData, encoding: String.Encoding.utf8) else{
                print("Ecode response data error")
                return
            }
            
            guard let ipInfo = self.parseResponse(response: dataString) else{
                print("Ecode response data error")
                return
            }
            complete(ipInfo)
        }.resume()
    }
    
    func parseResponse(response: String) -> IPInfo?{
        
        guard let context = jsContext else {
            print("JSContext can not found")
            return nil
        }
        
        // 提取字符串中的JSON字符串
        let extractFunction = context.objectForKeyedSubscript("extractResponse")
        guard let extracted = extractFunction?.call(withArguments: [response]).toString() else {
            print("Unable to extract JSON")
            return nil
        }
        
        // 解析 JSON字符串
        let parseJsonFunction = context.objectForKeyedSubscript("parseJson")
        guard let parsedJson = parseJsonFunction?.call(withArguments: [extracted]).toDictionary() else {
            print("Unable to parse JSON")
            return nil
        }
        
        /* 两种方法执行解析 */
        
        // 一 JSExort协议 已经将IPInfo对象暴露给js，直接在js中对象解析
        let mapFunction = context.objectForKeyedSubscript("mapToNative")
        guard let ipInfo = mapFunction?.call(withArguments: [parsedJson]).toObject() as? IPInfo else {
                print("Unable to parse JSON to Native Object")
                return nil
        }
        return ipInfo

        // 二 js调用native Block方法
        // 1  block 类型转换成泛型
//        let factoryBlock = unsafeBitCast(IPInfo.ipInfoFactory, to: AnyObject.self)
//        // 2
//        context.setObject(factoryBlock, forKeyedSubscript: "ipInfoFactory" as (NSCopying & NSObjectProtocol)!)
//        let factory = context.evaluateScript("ipInfoFactory")
//        // 3 调用native Block
//        guard
//            let ipInfo = factory?.call(withArguments: [parsedJson]).toObject() as? IPInfo else {
//                print("Error while processing ipInfo.")
//                return nil
//            
//        }
//        return ipInfo
    }

}
