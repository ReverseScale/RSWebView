# RSWebView
基于 Swift 的 WebView 封装
---
![](https://img.shields.io/badge/platform-iOS-red.svg) 
![](https://img.shields.io/badge/language-Swift-orange.svg) 
![](https://img.shields.io/badge/download-2.4MB-brightgreen.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

基于 Swift 实现的WebView封装，支持明暗两种模态推出及常用的导航控制器推出方式，更加入与JS交互的桥接案例。

| 名称 |1.列表页 |2.导航推出 |3.模态推出 |3.桥接示例 |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/17-11-21/19993848.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-11-21/63161250.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-11-21/17450424.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-11-21/15412962.jpg) |
| 描述 | 通过 storyboard 搭建基本框架 | push 推出视图封装 | Modal (暗版)推出视图封装 | JS原生交互演示页 |


## Advantage 框架的优势
* 1.文件少，代码简洁
* 2.基于 WKWebView 高度封装包括代理方法
* 3.枚举方法实现主体风格实现，灵活可扩展
* 4.基于 WebViewBridge.Swift 实现 JS 与原生（Swift）交互
* 5.具备较高自定义性

## Installation 安装
### 1.手动安装:
`下载Demo后,将功能文件夹拖入到项目中, 导入头文件后开始使用。`
### 2.CocoaPods安装:
修改“Podfile”文件
```
pod 'WebViewBridge.Swift', '~> 2.1'
```
控制台执行 Pods 安装命令 （ 简化安装：pod install --no-repo-update ）
```
pod install
```
> 如果 pod search 发现不是最新版本，在终端执行pod setup命令更新本地spec镜像缓存，重新搜索就OK了

## Requirements 要求
* iOS 7+
* Xcode 8+
* Swift 4.0


## Usage 使用方法
### 封装使用
Push 推出
```
let webVC = SwiftWebVC(urlString: "https://www.bing.com")
webVC.delegate = self
self.navigationController?.pushViewController(webVC, animated: true)
```
跳转 App Store
```
let webVC = SwiftWebVC(urlString: "https://itunes.apple.com/us/app/habitminder/id1253577148?mt=8")
webVC.delegate = self
self.navigationController?.pushViewController(webVC, animated: true)
```
model 弹出（主题效果）
```
let webVC = SwiftModalWebVC(urlString: "https://www.bing.com", theme: .lightBlack, dismissButtonStyle: .cross)
//let webVC = SwiftModalWebVC(urlString: "https://www.bing.com", theme: .dark, dismissButtonStyle: .arrow)
self.present(webVC, animated: true, completion: nil)
```
### JS与原生（Swift）交互
1. 引入头文件
```
import WebViewBridge_Swift
```
2. 搭建桥
```
var bridge:ZHWebViewBridge!
 //建立桥
bridge = ZHWebViewBridge.bridge(webView)
```
3.1 Native -> JS
```
/* Swift 部分
 * <1.2>原生调用 JS
 * 原生代码调用 js handler(在 HTML 或者 JS 中定义)
 * bridge.callJsHandler(handlerName, argArrayPassToJs, callback)
 */
bridge.registerHandler("Time.GetCurrentTime") { [weak self](args:[Any]) -> (Bool, [Any]?) in
    self?.bridge.callJsHandler("Time.updateTime", args: [Date.init().description])
    return (true, nil)
}
bridge.registerHandler("Device.GetAppVersion") { [weak self](args:[Any]) -> (Bool, [Any]?) in
    self?.bridge.callJsHandler("Device.updateAppVersion", args: [Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String], callback: { (data:Any?) in
        if let data = data as? String {
            let alert = UIAlertController.init(title: "Device.updateAppVersion", message: data, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { [weak self](_:UIAlertAction) in
                self?.dismiss(animated: false, completion: nil)
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    })
    return (true, nil)
}
```
```
    /* JS 部分
     * <1.1>原生调用 JS
     * 在 html 中或业务 js 中添加 js handler
     * - ZHBridge.Core.registerJsHandler(handlerName, callback)
     */
    ZHBridge.Core.registerJsHandler("Image.updateImageAtIndex", MYBusiness.Image.updateImageAtIndex);
```
3.2 JS -> Native
```
/* Swift 部分
 * <2.1>JS 调用原生
 * 原生代码中, bridge 注册 native handler
 * bridge.registerHandler(handlerName)
 */
bridge.registerHandler("Image.updatePlaceHolder") { (args:[Any]) -> (Bool, [Any]?) in
    return (true, ["place_holder.png"])
}
bridge.registerHandler("Image.ViewImage") { [weak self](args:[Any]) -> (Bool, [Any]?) in
    if let index = args.first as? Int , args.count == 1 {
        self?.viewImageAtIndex(index)
        return (true, nil)
    }
    return (false, nil)
}
bridge.registerHandler("Image.DownloadImage") { [weak self](args:[Any]) -> (Bool, [Any]?) in
    if let index = args.first as? Int , args.count == 1 {
        self?.downloadImageAtIndex(index)
        return (true, nil)
    }
    return (false, nil)
}
```
```
  /* JS 部分
   * <2.2>JS 调用原生
   * 在原生中添加的 handler
   * - ZHBridge.Core.callNativeHandler(handlerName, argArrayPassToNativeHandler, successCallback, failCallback)
   */

  ZHBridge.Core.callNativeHandler("Image.ViewImage", [parseInt(this.id)]);
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!


## License 许可证
RSWebView 使用 MIT 许可证，详情见 LICENSE 文件。


## Contact 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io
