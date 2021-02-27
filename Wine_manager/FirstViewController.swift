//
//  FirstViewController.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/07/25.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit
import PopupDialog

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var TrueTime: Date?
    var limitAPI: Int = 10
    var cannotGetTime: Int = 0
    var currentSpan: String?
    var documentDir = NSHomeDirectory() + "/Documents"
    var country_holder = ""
    var name_holder = ""
    var value_holder = ""
    var cellList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        csvSerch()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createDateCsv() { // 日毎に飲んだワインを記録するためのcsv
        do {
            cellList = []
            var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
            try existFile = FileManager.default.contentsOfDirectory(atPath: self.documentDir) // Documents以下のファイルを取得
            var csvData = ""
            var csvPath = self.documentDir + "/" // 保存するcsvファイルのパス
            print (existFile)
            if existFile.count == 0 {
                cellList = ["データがありません．"]
            } else {
                var dataList: [String] = []
                for csvFile in existFile {
                    csvPath = self.documentDir + "/" + csvFile // 保存するcsvファイルのパス
                    csvData = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
                    dataList = csvData.components(separatedBy: ",")
                    print (dataList)
                    let tmpList = [dataList[1], dataList[2], dataList[3]]
                    if dataList[6] == "1" {
                        csvData = tmpList.joined(separator: " ") // 配列内の要素を改行を入れて文字列に変換
                        cellList.append(csvData) // 表示するデータ
                    }
                }
            }
        } catch {
            print("error2 in createDataCsv")
        }
    }
    
    func csvSerch() {
        do {
            cellList = []
            var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
            try existFile = FileManager.default.contentsOfDirectory(atPath: self.documentDir) // Documents以下のファイルを取得
            var csvData = ""
            var csvPath = self.documentDir + "/" // 保存するcsvファイルのパス
            print (existFile)
            if existFile.count == 0 {
                cellList = ["ワインサーバーにワインが一本もありません．"]
            } else {
                var dataList: [String] = []
                for csvFile in existFile {
                    if csvFile == "photo" {
                        continue
                    } else if csvFile == "date" {
                        continue
                    } 
                    csvPath = self.documentDir + "/" + csvFile // 保存するcsvファイルのパス
                    csvData = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
                    dataList = csvData.components(separatedBy: ",")
                    print (dataList)
                    let tmpList = [dataList[1], dataList[2], dataList[3]]
                    if dataList[6] == "1" {
                        csvData = tmpList.joined(separator: " ") // 配列内の要素を改行を入れて文字列に変換
                        cellList.append(csvData) // 表示するデータ
                    }
                }
            }
        } catch {
            print("error2 in csvSearch")
        }
        if cellList.count == 0 {
            cellList = ["ワインサーバーにワインが一本もありません．"]
        }
        self.tableView.reloadData()
    }
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return cellList.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = cellList[indexPath.row]
        return cell
    }
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellText = tableView.cellForRow(at: indexPath as IndexPath)?.textLabel?.text
        do {
            var dataList = cellText?.components(separatedBy: " ")
            if dataList?.count == 1 {
                return
            }
            let name = dataList![0]
            let color = dataList![2]
            let csvFile = color + "_" + name + ".csv"
            let csvPath = self.documentDir + "/" + csvFile // 保存するcsvファイルのパス
            let csvData = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
            dataList = csvData.components(separatedBy: ",")
            delegate.nameOfWine = dataList![1]
            delegate.country = dataList![2]
            delegate.colorOfWine = dataList![3]
            delegate.value = dataList![4]
            delegate.comment = dataList![5]
        } catch {
            print("error")
        }

        let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
        let nextView = storyboard.instantiateViewController(withIdentifier:)("Detail") // UIViewControllerのクラスへ遷移する事を宣言
        self.present(nextView, animated: true, completion: nil) //画面の遷移
//        eraseCell(cellText: cellText!)
    }

    func syncBack (_ after:@escaping (UITabBarController?) -> ()) {
        let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
        let nextView = storyboard.instantiateViewController(withIdentifier:)("stock") // UIViewControllerのクラスへ遷移する事を宣言
        print(nextView)
        self.delegate.view = ""
        self.present(nextView, animated: true, completion: nil) //画面の遷移>
        after(nextView as! UITabBarController)
    }
    
    @IBAction func pushAddition(_ sender: Any) {
        let vc = PopupViewController(nibName: "PopupViewController", bundle: nil)
        // 表示したいビューコントローラーを指定してポップアップを作る
        let popup = PopupDialog(viewController: vc)
        vc.label2.text = "ワインの情報を入力してください．"
        // プレースホルダー
        vc.country.text = country_holder
        vc.country.placeholder = "国を入力"
        vc.country.clearButtonMode = .always
        vc.name.text = name_holder
        vc.name.placeholder = "銘柄を入力"
        vc.name.clearButtonMode = .always
        vc.value.text = value_holder
        vc.value.placeholder = "値段を入力"
        vc.value.clearButtonMode = .always
        var buttonOK: DefaultButton?
        buttonOK = DefaultButton(title: "ワイン追加", dismissOnTap: true) {
            let country = vc.country.text
            self.country_holder = vc.country.text!
            let name = vc.name.text
            self.name_holder = vc.name.text!
            let value = vc.value.text
            self.value_holder = vc.value.text!
            var comment = vc.textView.text
            if comment == "" {
                comment = "説明はありません．"
            }
            if (name != "" && country != "" && value != "") { // 入力ある場合
                var color = ""
                if vc.redORWhite.selectedSegmentIndex == 0 {
                    color = "赤"
                } else if vc.redORWhite.selectedSegmentIndex == 1 {
                    color = "白"
                }
                print (vc.textView.text)
                var dataString = ""
                let date = NSDate()
                let formatter1: DateFormatter = DateFormatter()
                formatter1.calendar = Calendar(identifier: .gregorian)
                formatter1.dateFormat = "yyyyMMdd"
                formatter1.locale = Locale(identifier: "ja-JP")
                let today_str = formatter1.string(from: date as Date)
                let cptoday = formatter1.date(from: today_str)
                print (today_str)
                print (date)
                let csvFile = color + "_" + name! + ".csv"
                let csvPath = self.documentDir + "/" + csvFile // 保存するcsvファイルのパス
                do {
                    var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
                    try existFile = FileManager.default.contentsOfDirectory(atPath: self.documentDir) // Documents以下のファイルを取得
                    print (existFile)
                    dataString = today_str + "," + name! + "," + country!
                    dataString = dataString + "," + color
                    dataString = dataString + "," + value! + "," + comment! + ",1"
                    if (existFile.index(of: csvFile) == nil) { // 対応するファイルがない場合
                        do {
                            print (dataString)
                            try dataString.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            print ("error1")
                        }
                    } else {
                        var dataList = dataString.components(separatedBy: ",")
                        dataList[6] = "1"
                        dataString = dataList.joined(separator: ",")
                        try dataString.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8)
                        print ("あるよ")
                        // あるよっていうポップアップを後で書く
                    }
                } catch {
                    print("error2")
                }
                print("OK")
                if self.delegate.pickedImage != nil {
                    self.save_photo(pickedImage: self.delegate.pickedImage!, color: color, name: name!) // アプリ内に保存
                }
                if self.delegate.mode == "take" { // 写真を撮ったときだけカメラロールに保存
                    // カメラロールに保存
                    UIImageWriteToSavedPhotosAlbum(self.delegate.pickedImage!, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
                    self.delegate.mode = ""
                }
            } else {
                let popupTitle = "未入力の項目があります．"
                let message = "必須の項目を入力してください．"
                let popup2 = PopupDialog(title: popupTitle, message: message)
                // Create buttons
                let button = DefaultButton(title: "OK", height: 60) {
                    print("OK")
                }
                popup2.addButton(button)
                self.present(popup2, animated: true, completion: nil)
            }
            self.csvSerch()
        }
        // ポップアップにボタンを追加
        popup.addButton(buttonOK!)
        // 作成したポップアップを表示する
        present(popup, animated: true, completion: nil)
    }
    func save_photo(pickedImage: UIImage, color: String, name: String) {
        if let photoData = UIImagePNGRepresentation(pickedImage) { // セレクトも撮る場合もアプリに保存
            // 保存ディレクトリ: Documents/Photo/
            let fileManager = FileManager.default
            //                    let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingPathComponent("photo") as NSString
            let dir = NSHomeDirectory() + "/Documents/photo/"
            if !fileManager.fileExists(atPath: dir) {
                do {
                    try fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    print("Unable to create directory: \(error)")
                }
            }
            // ファイル名: 現在日時.png
            let photoName = color + "_" + name + ".png"
            let path = dir + photoName
            // 保存
            do {
                var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
                try existFile = FileManager.default.contentsOfDirectory(atPath: dir) // Documents以下のファイルを取得
                print ("photo", existFile)
                try photoData.write(to: URL(fileURLWithPath: path), options: .atomic)
                print ("保存完了")
                delegate.pickedImage = pickedImage
            } catch {
                
            }
        }
    }
    
    // 保存を試みた結果をダイアログで表示
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }
    func addWine(country: String, name: String, value: String) -> Void {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}





