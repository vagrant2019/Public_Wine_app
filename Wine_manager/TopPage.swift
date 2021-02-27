//
//  TopPage.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/07/26.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit

class TopPage: UITabBarController {

    var documentDir = NSHomeDirectory() + "/Documents"
    override func viewDidLoad() {
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        super.viewDidLoad()
        if (delegate.view == "stock") {
            self.selectedIndex = 0 // 一番左が0
        } else if (delegate.view == "calendar") {
            self.selectedIndex = 1 // 一番左が0
        } else if (delegate.view == "search") {
            self.selectedIndex = 3 // 一番左が0
        }
        delegate.view = ""
        let newDir = self.documentDir + "/" + "date" // 作成するディレクトリのパス
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: newDir) { // 最初はdateディレクトリを作成
            do {
                try fileManager.createDirectory(atPath: newDir, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Unable to create directory: \(error)")
            }
        }
        let dir = NSHomeDirectory() + "/Documents/photo/"
        if !fileManager.fileExists(atPath: dir) {
            do {
                try fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Unable to create directory: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
