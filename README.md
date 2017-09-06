# JSCore-IPQuery-Demo
jsCore Simple Demo 

简单的IP归属地查询 两种方式解析JSON

```swift
// 一 JSExort协议 已经将IPInfo对象暴露给js，直接在js中对象解析
let mapFunction = context.objectForKeyedSubscript("mapToNative")
guard let ipInfo = mapFunction?.call(withArguments: [parsedJson]).toObject() as? IPInfo else {
      print("Unable to parse JSON to Native Object")
       return nil
      }
```

```swift
// 1  block 类型转换成泛型
let factoryBlock = unsafeBitCast(IPInfo.ipInfoFactory, to: AnyObject.self)
// 2
context.setObject(factoryBlock, forKeyedSubscript: "ipInfoFactory" as (NSCopying & NSObjectProtocol)!)
let factory = context.evaluateScript("ipInfoFactory")
// 3 调用native Block
 guard
     let ipInfo = factory?.call(withArguments: [parsedJson]).toObject() as? IPInfo else {
     print("Error while processing ipInfo.")
     return nil    
     }
```
![image](https://github.com/madaoCN/JSCore-IPQuery-Demo/blob/master/screenshot.png)
