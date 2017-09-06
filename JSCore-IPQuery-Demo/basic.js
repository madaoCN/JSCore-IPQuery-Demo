/* 
  basic.js
  JSCore-IPQuery-Demo

  Created by 梁宪松 on 2017/9/6.
  Copyright © 2017年 Madao. All rights reserved.
*/

// 提取字符串中Json数据
var extractResponse = function(str){

    var pattern = /{.+?}/;
    var result = pattern.exec(str);
    return result ? result[0] : null

};

// 解析Json字符串
var parseJson = function(json) {
    
    var data = JSON.parse(json);
    return data;
};

// 字典生成对象
var mapToNative = function(ipInfo) {
    return IPInfo.ipInfoWithCountryProvinceCityDistrict(ipInfo.country,
                                                        ipInfo.province,
                                                        ipInfo.city,
                                                        ipInfo.district,
                                                        );
};
