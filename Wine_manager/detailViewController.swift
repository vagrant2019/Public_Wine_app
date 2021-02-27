//
//  detailViewController.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/07/31.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit
import PopupDialog

class detailViewController: UIViewController, UITextViewDelegate  {
    
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var country_label: UILabel!
    @IBOutlet weak var value_label: UILabel!
    @IBOutlet weak var color_label: UILabel!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var comment2: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var documentDir = NSHomeDirectory() + "/Documents"
    var toolBar:UIToolbar!
    // デフォルトでは１週間前からその日までを選択
    let date = Date()
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    var today: String?
    
    @IBOutlet weak var dateTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        color_label.text = delegate.colorOfWine
        //グラデーションの開始色
        var bottomColor = UIColor(red:1, green:0.996, blue:0.902, alpha:0.9)
        //グラデーションの開始色
        var topColor = UIColor(red:1, green:0.996, blue:0.902, alpha:0.4)
        if color_label.text == "赤" {
            //グラデーションの開始色
            bottomColor = UIColor(red:1, green:0.745, blue:0.902, alpha:0.9)
            //グラデーションの開始色
            topColor = UIColor(red:1, green:0.745, blue:0.902, alpha:0.4)
        }
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.view.bounds
        //グラデーションレイヤーをビューの一番下に配置
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        name_label.text = delegate.nameOfWine
        country_label.text = delegate.country
        value_label.text = delegate.value
        comment.text = delegate.comment
        comment.isEditable = false
        comment.layer.borderColor = UIColor.black.cgColor
        comment.layer.borderWidth = 1.0
        comment.layer.cornerRadius = 10.0
        comment.layer.masksToBounds = true
        comment2.layer.borderColor = UIColor.black.cgColor
        comment2.layer.borderWidth = 1.0
        comment2.layer.cornerRadius = 10.0
        comment2.layer.masksToBounds = true
        comment2.delegate = self as! UITextViewDelegate
        var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
        let photoDir = self.documentDir + "/photo"
        let noImageFile = "noimage.png"
        var image = UIImage(named: noImageFile)
        do {
            try existFile = FileManager.default.contentsOfDirectory(atPath: photoDir) // Documents以下のファイルを取得
            let pngFile = color_label.text! + "_" + name_label.text! + ".png"
            if (existFile.index(of: pngFile) != nil) { // 写真がある場合
                image = UIImage(named: photoDir + "/" + pngFile)
                if ((image?.size.height)! / (image?.size.width)!) < 1.77 { // フルHDの比率じゃなかったら回転
                    image = image?.rotatedBy(degree: 90)
                }
            }
            imageView.contentMode = .scaleAspectFit
            //                let resizeImage = image?.resizeMaintainDirection(size:CGSize(width:94,height:345))
            self.imageView.image = image
        } catch {
            print ("error in viewDidLoad")
        }
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
        // Do any additional setup after loading the view.
    }
    @objc func doneBtn(sender: UIButton){
        dateTextField.resignFirstResponder()
    }
    @objc func start_changedDateEvent(sender:AnyObject?){
        var dateSelecter: UIDatePicker = sender as! UIDatePicker
        let str = self.dateFormat.string(from: datePicker.date)
        self.dateTextField.text = str
    }
    @IBAction func pushBack(_ sender: Any) {
        delegate.view = "stock"
        let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
        let nextView = storyboard.instantiateViewController(withIdentifier:)("Top") // UIViewControllerのクラスへ遷移する事を宣言
        self.present(nextView, animated: true, completion: nil) //画面の遷移
    }
    
    @IBAction func pushConsume(_ sender: Any) {
        let popupTitle = "このワインを美味しくいただきますか？"
        let message = "感想は書きましたか？書きたい場合はキャンセルを押して感想を入力してから再度消費ボタンを押してください．"
        let popup2 = PopupDialog(title: popupTitle, message: message)
        // Create buttons
        let button = DefaultButton(title: "ワインを消費", dismissOnTap: true) {
            self.eraseCell(name: self.delegate.nameOfWine, color: self.delegate.colorOfWine)
            let popupTitle = "ワインを消費しました．"
            let message = "在庫管理画面に戻ります．"
            let popup2 = PopupDialog(title: popupTitle, message: message)
            // Create buttons
            let button = DefaultButton(title: "OK", height: 60) {
                print("OK")
                let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
                let nextView = storyboard.instantiateViewController(withIdentifier:)("Top") // UIViewControllerのクラスへ遷移する事を宣言
                self.present(nextView, animated: true, completion: nil) //画面の遷移
            }
            
            let csvFile = self.color_label.text! + "_" + self.name_label.text! + ".csv"
            let csvPath = self.documentDir + "/" + csvFile // 保存するcsvファイルのパス
            var dataString = ""
            do {
                var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
                try existFile = FileManager.default.contentsOfDirectory(atPath: self.documentDir) // Documents以下のファイルを取得
                print (existFile)
                var dataString = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
                var dataList = dataString.components(separatedBy: ",")
                dataList.append(self.comment2.text)
                dataList[0] = self.today! // 飲んだ日を追加
                dataString = dataList.joined(separator: ",")
                print ("感想追加", dataString)
                try dataString.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8)
                print ("あるよ")
            } catch {
                print ("error1")
            } // あるよっていうポップアップを後で書く
            popup2.addButton(button)
            self.present(popup2, animated: true, completion: nil)
        }
        let button2 = DefaultButton(title: "キャンセル", height: 60) {
            print("キャンセル")
        }
        popup2.addButtons([button, button2])
        self.present(popup2, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func eraseCell(name: String, color: String) { // 消費したフラグと感想を書く
        //let dataList = cellText.components(separatedBy: ",")
        do {
            var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
            try existFile = FileManager.default.contentsOfDirectory(atPath: self.documentDir) // Documents以下のファイルを取得
            let csvFile = color + "_" + name + ".csv"
            let csvPath = self.documentDir + "/" + csvFile// 削除するcsvファイルのパス
            if (existFile.index(of: csvFile) != nil) { // 対応するファイルがある場合
                var csvData = try String(contentsOfFile: csvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
                var dataList = csvData.components(separatedBy: ",") // ["5,H", "6,G", "4,C", ""]の様な配列に変換
                dataList[6] = "0" // 消費したことを示すフラグは0
                csvData = dataList.joined(separator: ",")
                try csvData.write(toFile: csvPath, atomically: true, encoding: String.Encoding.utf8) // csvへ書き込み
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
                self.today = sDate
                dataList[0] = today_str
                print ("today", today_str)
                let dateCsvFile = today_str + ".csv" // その日に飲んだワインのcsvファイル名 2018_08_01,csv
                var dateCsvData = csvFile + "\n"
                let dateCsvPath = self.documentDir + "/" + "date/" + dateCsvFile // csvファイルのパス
                let newDir = self.documentDir + "/" + "date" // 作成するディレクトリのパス
                try existFile = FileManager.default.contentsOfDirectory(atPath: newDir) // date以下のファイルを取得
                let csvFile = color + "_" + name + ".csv"
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
                    csvData = try String(contentsOfFile: dateCsvPath, encoding:String.Encoding.utf8) //読み込んだデータ(文字列)
                    print ("csvData", csvData)
                    dateCsvData = csvData + dateCsvData // 読み込んだデータと新規データをくっつける
                    print (dateCsvData)
                    try dateCsvData.write(toFile: dateCsvPath, atomically: true, encoding: String.Encoding.utf8) // csvへ書き込み
                }
            }
        } catch {
            print ("errorrrrr")
            // エラー
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.comment2.isFirstResponder) {
            self.comment2.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension UIImage {
    
    func rotatedBy(degree: CGFloat) -> UIImage {
        let radian = -degree * CGFloat.pi / 180
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width / 2, y: self.size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: self.size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }
    
    func resize(size:CGSize) -> UIImage?{
        // リサイズ処理
        let origWidth = self.size.width
        let origHeight = self.size.height
        
        var resizeWidth:CGFloat = 0
        var resizeHeight:CGFloat = 0
        if (origWidth < origHeight) {
            resizeWidth = size.width
            resizeHeight = origHeight * resizeWidth / origWidth
        } else {
            resizeHeight = size.height
            resizeWidth = origWidth * resizeHeight / origHeight
        }
        
        let resizeSize = CGSize(width:resizeWidth, height:resizeHeight)
        UIGraphicsBeginImageContext(resizeSize)
        
        self.draw(in: CGRect(x:0,y: 0,width: resizeWidth, height: resizeHeight))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 切り抜き処理
        let cropRect = CGRect(x:( resizeWidth - size.width ) / 2,
                              y:( resizeHeight - size.height) / 2,
                              width:size.width,
                              height:size.height)
        
        if let cropRef = resizeImage?.cgImage {
            cropRef.cropping(to: cropRect)
            let cropImage = UIImage(cgImage: cropRef)
            return cropImage
        }else {
            print("error!")
            return nil
        }
    }
    
    //向きがおかしくなる時用
    func resizeMaintainDirection(size:CGSize) -> UIImage?{
        
        //縦横がおかしくなる時は一度書き直すと良いらしい
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        self.draw(in:CGRect(x:0,y:0,width:self.size.width,height:self.size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        // リサイズ処理
        let origWidth = image.size.width
        let origHeight = image.size.height
        
        var resizeWidth:CGFloat = 0
        var resizeHeight:CGFloat = 0
        if (origWidth < origHeight) {
            resizeWidth = size.width
            resizeHeight = origHeight * resizeWidth / origWidth
        } else {
            resizeHeight = size.height
            resizeWidth = origWidth * resizeHeight / origHeight
        }
        
        let resizeSize = CGSize(width:resizeWidth, height:resizeHeight)
        UIGraphicsBeginImageContext(resizeSize)
        
        image.draw(in: CGRect(x:0,y: 0,width: resizeWidth, height: resizeHeight))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 切り抜き処理
        let cropRect = CGRect(x:( resizeWidth - size.width ) / 2,
                              y:( resizeHeight - size.height) / 2,
                              width:size.width,
                              height:size.height)
        
        if let cropRef = resizeImage?.cgImage {
            cropRef.cropping(to: cropRect)
            let cropImage = UIImage(cgImage: cropRef)
            return cropImage
        }else {
            print("error!")
            return nil
        }
    }
}
