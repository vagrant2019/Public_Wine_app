//
//  SearchViewController.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/08/02.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit
import PopupDialog

class SearchViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var documentDir = NSHomeDirectory() + "/Documents"
    let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var redORWhite: UISegmentedControl!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var result_textField: UITextView!
    @IBOutlet weak var detail_button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        result_textField.layer.borderColor = UIColor.black.cgColor
        result_textField.layer.borderWidth = 1.0
        result_textField.layer.cornerRadius = 10.0
        result_textField.layer.masksToBounds = true
        result_textField.delegate = self as! UITextViewDelegate
        result_textField.isEditable = false
        detail_button.isEnabled = false
        detail_button.alpha = 0.3
        name.delegate = self as! UITextFieldDelegate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search() {
        var color = ""
        if redORWhite.selectedSegmentIndex == 0 {
            color = "赤"
        } else if redORWhite.selectedSegmentIndex == 1 {
            color = "白"
        }
        let csvFile = color + "_" + name.text! + ".csv"
        let csvPath = self.documentDir + "/" + csvFile// 削除するcsvファイルのパス
        var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
        do {
            try existFile = FileManager.default.contentsOfDirectory(atPath: documentDir) // date以下のファイルを取得
            print ("サーチ", existFile)
            if (existFile.index(of: csvFile) == nil) { // 対応するファイルがない場合
                result_textField.text = "該当するワインのデータがありませんでした．"
                detail_button.isEnabled = false
                detail_button.alpha = 0.3
                // 詳細ボタン押せなくする
            } else {
                detail_button.isEnabled = true
                detail_button.alpha = 1
                let csvData = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
                let dataList = csvData.components(separatedBy: ",")
                delegate.nameOfWine = dataList[1]
                delegate.country = dataList[2]
                delegate.colorOfWine = dataList[3]
                delegate.value = dataList[4]
                delegate.comment = dataList[5] // コメント
                delegate.comment2 = "感想はありません．"
                if dataList.count == 8 {
                    if dataList[7] != "" {
                        delegate.comment2 = dataList[7] // 感想
                    }
                }
                var drinkdate = ""
                var tmp = dataList[0]
                var ST1 = tmp.index(tmp.startIndex, offsetBy:4)
                tmp.insert("年", at: ST1)
                ST1 = tmp.index(tmp.startIndex, offsetBy:7)
                tmp.insert("月", at: ST1)
                ST1 = tmp.index(tmp.startIndex, offsetBy:10)
                tmp.insert("日", at: ST1)
                drinkdate = tmp
                if dataList[6] == "0" {
                result_textField.text = "該当するワインのデータが見つかりました．\n最後にこのワインを飲んだのは" + drinkdate + "です．\n詳細を表示するには詳細ボタンを押してください．"
                } else {
                result_textField.text = "該当するワインのデータが見つかりました．\nこのワインは現在ワインサーバにあります．\n" + drinkdate + "にワインサーバに保管されました．\n詳細を表示するには詳細ボタンを押してください．"
                }
            }
        } catch {
            print ("ファイル取得失敗")
        }
    }
    @IBAction func pushSearch(_ sender: Any) {
        if name.text != "" {
            search()
        } else {
            let popupTitle = "検索できません．"
            let message = "銘柄を入力してください．"
            let popup2 = PopupDialog(title: popupTitle, message: message)
            // Create buttons
            let button = DefaultButton(title: "OK", height: 60) {
                print("OK")
            }
            popup2.addButton(button)
            self.present(popup2, animated: true, completion: nil)
        }
    }
    
    @IBAction func pushDetail(_ sender: Any) {
        delegate.view = "search"
        let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
        let nextView = storyboard.instantiateViewController(withIdentifier:)("Detail2") // UIViewControllerのクラスへ遷移する事を宣言
        self.present(nextView, animated: true, completion: nil) //画面の遷移
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除
    }
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
            
        })
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.name.isFirstResponder) {
            self.name.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
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
