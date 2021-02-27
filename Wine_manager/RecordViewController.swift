//
//  RecordViewController.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/08/01.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var daylabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var cellList: [String] = []
    var dateDir = NSHomeDirectory() + "/Documents/date"
    var documentDir = NSHomeDirectory() + "/Documents"
    override func viewDidLoad() {
        super.viewDidLoad()
        // カレンダーのUIViewControllerから渡された(year, month, day)のdayを取得しラベルに表示
        cellList = []
        let year = (delegate.message?.0.description)!
        var month = (delegate.message?.1.description)!
        var day = (delegate.message?.2.description)!
        if (month.count == 1) {
            month = "0" + month
        }
        if (day.count == 1) {
            day = "0" + day
        }
        let str = year + "年" + month + "月" + day + "日に飲んだワイン"
        self.daylabel.text = str
        let csvFile = year + month + day + ".csv"
        var csvPath = dateDir + "/" + csvFile
        var dataList: [String] = []
        do {
            var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
            try existFile = FileManager.default.contentsOfDirectory(atPath: dateDir) // Documents以下のファイルを取得
            if (existFile.index(of: csvFile) == nil) { // 対応するファイルがない場合
                cellList = ["この日に飲んだワインはありません．"]
            } else { // ある場合
                do {
                    var csvData = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
                    let csvFileList = csvData.components(separatedBy: "\n") // ["aa.csv", "bb.csv", "cc.csv"]の様な配列に変換
                    print (csvFileList)
                    for csvFile in csvFileList {
                        csvPath = documentDir + "/" + csvFile // csvファイルのパス
                        csvData = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8)
                        print ("csvData", csvData)
                        dataList = csvData.components(separatedBy: ",") // [20180801, name, country, color,...]
                        let tmpList = [dataList[1], dataList[2], dataList[3]]
                        if dataList[6] == "0" {
                            csvData = tmpList.joined(separator: " ") // 配列内の要素を改行を入れて文字列に変換
                            cellList.append(csvData) // 表示するデータ
                        }
                    }
                } catch {
                    print ("error")
                }
            }
        } catch {
            print("error(date)")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushBack(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
        delegate.view = "calendar"
        let nextView = storyboard.instantiateViewController(withIdentifier:)("Top") // UIViewControllerのクラスへ遷移する事を宣言
        self.present(nextView, animated: true, completion: nil) //画面の遷移
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
            let csvPath = documentDir + "/" + csvFile // 保存するcsvファイルのパス
            let csvData = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
            dataList = csvData.components(separatedBy: ",")
            delegate.nameOfWine = dataList![1]
            delegate.country = dataList![2]
            delegate.colorOfWine = dataList![3]
            delegate.value = dataList![4]
            delegate.comment = dataList![5] // コメント
            delegate.comment2 = "感想はありません．"
            if dataList![7] != "" {
                delegate.comment2 = dataList![7] // 感想
            }
            
        } catch {
            print("error")
        }
        delegate.view = "recordTable"
        let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
        let nextView = storyboard.instantiateViewController(withIdentifier:)("Detail2") // UIViewControllerのクラスへ遷移する事を宣言
        self.present(nextView, animated: true, completion: nil) //画面の遷移
        //        eraseCell(cellText: cellText!)
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
