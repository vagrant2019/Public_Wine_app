//
//  addViewController.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/08/02.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit
import PopupDialog

class addViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate  {
    let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var comment2: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var redORWhite: UISegmentedControl!
    var mode = ""
    var documentDir = NSHomeDirectory() + "/Documents"
    var country_holder = ""
    var name_holder = ""
    var value_holder = ""
    var cellList: [String] = []
    var toolBar:UIToolbar!
    // デフォルトでは１週間前からその日までを選択
    let date = Date()
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        country.text = country_holder
        country.placeholder = "国を入力"
        country.clearButtonMode = .always
        name.text = name_holder
        name.placeholder = "銘柄を入力"
        name.clearButtonMode = .always
        value.text = value_holder
        value.placeholder = "値段を入力"
        value.clearButtonMode = .always
        delegate.mode = ""
        delegate.pickedImage = nil
        self.imageView.image = UIImage(named: "default.png")
        self.name.delegate = self
        self.country.delegate = self
        self.value.delegate = self
        comment.layer.borderColor = UIColor.black.cgColor
        comment.layer.borderWidth = 1.0
        // 枠を角丸にする場合
        comment.layer.cornerRadius = 10.0
        comment.layer.masksToBounds = true
        comment.delegate = self as! UITextViewDelegate
        comment2.layer.borderColor = UIColor.black.cgColor
        comment2.layer.borderWidth = 1.0
        comment2.layer.cornerRadius = 10.0
        comment2.layer.masksToBounds = true
        comment2.delegate = self as! UITextViewDelegate
        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = dateFormat.string(from: date)
        // DatePickerの設定(日付用)
        // for 開始日
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        datePicker.addTarget(self, action: #selector(start_changedDateEvent(sender:)), for: UIControlEvents.valueChanged)
        datePicker.date = date
        datePicker.datePickerMode = UIDatePickerMode.date
        dateTextField.inputView = datePicker
        // UIToolBarの設定 完了ボタンの設置
        let ToolBarBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(doneBtn(sender:)))
        toolBar.items = [ToolBarBtn]
        dateTextField.inputAccessoryView = toolBar
        //     imageView.image = UIImage(named: "default.png")
    }
    
    @objc func doneBtn(sender: UIButton){
        dateTextField.resignFirstResponder()
    }
    @objc func start_changedDateEvent(sender:AnyObject?){
        var dateSelecter: UIDatePicker = sender as! UIDatePicker
        let str = self.dateFormat.string(from: datePicker.date)
        self.dateTextField.text = str
    }
    
    @IBAction func choosePicture(_ sender: Any) {
        delegate.mode = "choose"
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    @IBAction func resetPicture(_ sender: Any) {
        // アラートで確認
        let alert = UIAlertController(title: "確認", message: "画像を初期化してもよいですか？", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler:{(action: UIAlertAction) -> Void in
            // デフォルトの画像を表示する
            self.imageView.image = UIImage(named: "default.png")
        })
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        // アラートにボタン追加
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        // アラート表示
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pushTakePhoto(_ sender: Any) {
        delegate.mode = "take"
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    //　写真を選択および撮影が完了した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage]
            as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            delegate.pickedImage = pickedImage
        }
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // ビューに表示する
        self.imageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // 写真を選んだ後に呼ばれる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.comment.isFirstResponder) {
            self.comment.resignFirstResponder()
        }
        if (self.comment2.isFirstResponder) {
            self.comment2.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func pushAddition(_ sender: Any) {
        // プレースホルダー
        let country2 = self.country.text
        print ("ここです")
        print (country2)
        self.country_holder = country2!
        let name2 = self.name.text
        print (name2)
        self.name_holder = name2!
        let value2 = self.value.text
        print (value2)
        self.value_holder = value2!
        var comment_text = self.comment.text
        if comment_text == "" {
            comment_text = "説明はありません．"
        }
        var comment2_text = self.comment2.text
        if comment2_text == "" {
            comment2_text = "感想はありません．"
        }
        var sDate = self.dateTextField.text!
        let year = sDate.index(sDate.startIndex, offsetBy:4)
        let month = sDate.index(sDate.startIndex, offsetBy:6)
        let day = sDate.index(sDate.startIndex, offsetBy:8)
        // YYYY年MM月DD日にしたので年月日削除
        sDate.remove(at: year)
        sDate.remove(at: month)
        sDate.remove(at: day)
        print ("sDate", sDate)
        let today_str = sDate
        print (today_str)
        let popupTitle = "このワインを美味しくいただきますか？"
        let message = "感想は書きましたか？書きたい場合はキャンセルを押して感想を入力してから再度消費ボタンを押してください．"
        let popup2 = PopupDialog(title: popupTitle, message: message)
        // Create buttons
        let button = DefaultButton(title: "乾杯！", dismissOnTap: true) {
            var dataString = ""
            if (name2 != "" && country2 != "" && value2 != "") { // 入力ある場合
                var color = ""
                if self.redORWhite.selectedSegmentIndex == 0 {
                    color = "赤"
                } else if self.redORWhite.selectedSegmentIndex == 1 {
                    color = "白"
                }
                var dataString = ""
                print (self.date)
                let csvFile = color + "_" + name2! + ".csv"
                let csvPath = self.documentDir + "/" + csvFile // 保存するcsvファイルのパス
                do {
                    var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
                    try existFile = FileManager.default.contentsOfDirectory(atPath: self.documentDir) // Documents以下のファイルを取得
                    print (existFile)
                    dataString = today_str + "," + name2! + "," + country2!
                    dataString = dataString + "," + color
                    dataString = dataString + "," + value2!
                    dataString = dataString + "," + comment_text!
                    dataString = dataString + ",0," + comment2_text! 
                    if (existFile.index(of: csvFile) == nil) { // 対応するファイルがない場合
                        do {
                            print (dataString)
                            try dataString.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            print ("error1")
                        }
                    } else {
                        var dataList = dataString.components(separatedBy: ",")
                        dataList[6] = "0"
                        dataString = dataList.joined(separator: ",")
                        try dataString.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8)
                        print ("あるよ")
                        // あるよっていうポップアップを後で書く
                    }
                } catch {
                    print("error2")
                }
                print("OK")
                self.create_date_csv() // カレンダーに使うcsv作る
                if self.delegate.pickedImage != nil {
                    self.save_photo(pickedImage: self.delegate.pickedImage!, color: color, name: name2!) // アプリ内に保存
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
            let popupTitle = "ワインの情報をカレンダーに追加しました．"
            let message = "またひとつ思い出が増えましたね．"
            let popup2 = PopupDialog(title: popupTitle, message: message)
            // Create buttons
            let button = DefaultButton(title: "OK", height: 60) {
                print("OK")
                self.country.text = ""
                self.country.placeholder = "国を入力"
                self.name.text = ""
                self.name.placeholder = "銘柄を入力"
                self.value.text = ""
                self.value.placeholder = "値段を入力"
            }
            popup2.addButton(button)
            self.present(popup2, animated: true, completion: nil)
        }
        let button2 = DefaultButton(title: "キャンセル", height: 60) {
            print("キャンセル")
        }
        popup2.addButtons([button, button2])
        self.present(popup2, animated: true, completion: nil)
    }
    
    func create_date_csv() {
        var color = ""
        if redORWhite.selectedSegmentIndex == 0 {
            color = "赤"
        } else if redORWhite.selectedSegmentIndex == 1 {
            color = "白"
        }
        var dataString = ""
        var sDate = self.dateTextField.text!
        let year = sDate.index(sDate.startIndex, offsetBy:4)
        let month = sDate.index(sDate.startIndex, offsetBy:6)
        let day = sDate.index(sDate.startIndex, offsetBy:8)
        // YYYY年MM月DD日にしたので年月日削除
        sDate.remove(at: year)
        sDate.remove(at: month)
        sDate.remove(at: day)
        print ("sDate", sDate)
        let today_str = sDate
        print (today_str)
        let csvFile = color + "_" + name.text! + ".csv"
        let csvPath = self.documentDir + "/" + csvFile// 削除するcsvファイルのパス
        let dateCsvFile = today_str + ".csv" // その日に飲んだワインのcsvファイル名 2018_08_01,csv
        var dateCsvData = csvFile + "\n"
        let dateCsvPath = self.documentDir + "/" + "date/" + dateCsvFile // csvファイルのパス
        let newDir = self.documentDir + "/" + "date" // 作成するディレクトリのパス
        var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
        do {
            print ("aaaaaaaaaaaaaaaaa")
            try existFile = FileManager.default.contentsOfDirectory(atPath: newDir) // date以下のファイルを取得
            print ("あああああああ", existFile)
            
            if (existFile.index(of: dateCsvFile) == nil) { // 対応するファイルがない場合
                do { // 初書き込み
                    print ("1", dateCsvData)
                    print ("2", dateCsvPath)
                    try dateCsvData.write(toFile: dateCsvPath, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    print ("初書き込みエラー")
                }
            } else { // 追加の書き込み
                let csvData = try String(contentsOfFile: dateCsvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
                print ("csvData", csvData)
                dateCsvData = csvData + dateCsvData // 読み込んだデータと新規データをくっつける
                print (dateCsvData)
                try dateCsvData.write(toFile: dateCsvPath, atomically: true, encoding: String.Encoding.utf8) // csvへ書き込み
            }
        } catch {
            
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
