//
//  SwiftBridgeWebVC.swift
//  RSWebView
//
//  Created by WhatsXie on 2017/11/20.
//  Copyright © 2017年 R.S. All rights reserved.
//

import UIKit
import WebKit
import WebViewBridge_Swift

class SwiftBridgeWebVC: UIViewController {
    var webView:WKWebView!
    var bridge:ZHWebViewBridge<WKWebView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.frame = view.bounds
        view.addSubview(webView)
        
        webView.loadHTMLString(ZHData.instance.htmlData, baseURL:  URL.init(fileURLWithPath: ZHData.instance.imageFolder))
        
        //建立桥
        bridge = ZHWebViewBridge.bridge(webView)
        
        nativeToJs()
        jsToNative()
        otherJSAdd()
        
//        prepareResources()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    /*
     * <1.2>原生调用 JS
     * 原生代码调用 js handler(在 HTML 或者 JS 中定义)
     * bridge.callJsHandler(handlerName, argArrayPassToJs, callback)
     */
    func nativeToJs() {
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
    }
    
    /*
     * <2.1>JS 调用原生
     * 原生代码中, bridge 注册 native handler
     * bridge.registerHandler(handlerName)
     */
    func jsToNative() {
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
    }
    func otherJSAdd() {
        //<3>添加其他的插件代码(UIWebView 不支持)
        bridge.addUserPluginScript("your script")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension SwiftBridgeWebVC {
    func prepareResources() {
        let basePath = ZHData.instance.imageFolder
        let resources = ["place_holder.png", "bridge_core.js"]
        for resource in resources {
            if let path = Bundle.main.path(forResource: resource, ofType: nil) {
                let targetPath = (basePath as NSString).appendingPathComponent(resource)
                if !FileManager.default.fileExists(atPath: targetPath) {
                    _ = try? FileManager.default.copyItem(atPath: path, toPath: targetPath)
                }
            }
        }
    }
    
    func viewImageAtIndex(_ index:Int) {
        let alert = UIAlertController.init(title: "ViewImage atIndex \(index)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { [weak self](_:UIAlertAction) in
            self?.dismiss(animated: false, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func downloadImageAtIndex(_ index:Int) {
        let images = ZHData.instance.imageUrls
        if index < images.count {
            let image = images[index]
            ZHData.instance.downloadImage(image, handler: { [weak self](file:String) in
                self?.bridge.callJsHandler("Image.updateImageAtIndex", args: [file, index], callback: nil)
            })
            
        }
    }
    
    func downloadImages() {
        for (index, _) in ZHData.instance.imageUrls.enumerated() {
            downloadImageAtIndex(index)
        }
    }
}
