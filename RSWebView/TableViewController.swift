//
//  TableViewController.swift
//  RSWebView
//
//  Created by WhatsXie on 2017/11/17.
//  Copyright © 2017年 R.S. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushWebView()
        case 1:
            pushAppStore()
        case 2:
            modelWebView()
        case 3:
            modelWebViewDark()
        default:
            pushbridgeWebView()
        }
    }

    
    func pushWebView() {
        let webVC = SwiftWebVC(urlString: "https://www.bing.com")
        webVC.delegate = self
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    func pushAppStore() {
        let webVC = SwiftWebVC(urlString: "https://itunes.apple.com/us/app/habitminder/id1253577148?mt=8")
        webVC.delegate = self
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    func modelWebView() {
        let webVC = SwiftModalWebVC(urlString: "https://www.bing.com", theme: .lightBlack, dismissButtonStyle: .cross)
        self.present(webVC, animated: true, completion: nil)
    }
    func modelWebViewDark() {
        let webVC = SwiftModalWebVC(urlString: "https://www.bing.com", theme: .dark, dismissButtonStyle: .arrow)
        self.present(webVC, animated: true, completion: nil)
    }
    func pushbridgeWebView() {
        let webVC = SwiftBridgeWebVC()
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}

extension TableViewController: SwiftWebVCDelegate {
    func didStartLoading() {
        print("Started loading.")
    }
    
    func didFinishLoading(success: Bool) {
        print("Finished loading. Success: \(success).")
    }
}
