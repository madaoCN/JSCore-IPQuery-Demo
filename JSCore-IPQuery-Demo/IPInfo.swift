//
//  IPInfo.swift
//  JSCore-IPQuery-Demo
//
//  Created by 梁宪松 on 2017/9/6.
//  Copyright © 2017年 Madao. All rights reserved.
//

import UIKit
import JavaScriptCore


@objc protocol IPInfoExports: JSExport {
    var country: String { get set }
    var province: String { get set }
    var city: String { get set }
    var district: String { get set }
    
    static func ipInfoWith(country: String, province: String, city: String, district:String) -> IPInfo
}


class IPInfo: NSObject, IPInfoExports {
    
    class func ipInfoWith(country: String, province: String, city: String, district:String) -> IPInfo {
    
        return IPInfo(country: country, province: province, city: city, district:district)
    }
    
    dynamic var country: String
    dynamic var province: String
    dynamic var city: String
    dynamic var district: String
    
    // 从字典构造一个IPInfo对象, ps.计算数学
    static let ipInfoFactory: @convention(block) ([AnyHashable : Any]) -> IPInfo = {
        dict in
        guard
            let country = dict["country"] as? String,
            let province = dict["province"] as? String,
            let city = dict["city"] as? String ,
            let district = dict["district"] as? String else {
                print("unable to parse IPInfoFactory objects.")
                fatalError()
            }
        
        return IPInfo(country: country, province: province, city: city, district:district)
    }

    
    init(country: String, province: String, city: String, district:String) {
        self.country = country
        self.province = province
        self.city = city
        self.district = district
    }
}
