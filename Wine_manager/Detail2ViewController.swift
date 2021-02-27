//
//  Detail2ViewController.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/08/01.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit

class Detail2ViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var color_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var value_label: UILabel!
    @IBOutlet weak var country_label: UILabel!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var comment2: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var documentDir = NSHomeDirectory() + "/Documents"
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
        color_label.text = delegate.colorOfWine
        comment.text = delegate.comment
        comment.isEditable = false
        comment.layer.borderColor = UIColor.black.cgColor
        comment.layer.borderWidth = 1.0
        comment.layer.cornerRadius = 10.0
        comment.layer.masksToBounds = true
        comment2.text = delegate.comment2
        comment2.isEditable = false
        comment2.layer.borderColor = UIColor.black.cgColor
        comment2.layer.borderWidth = 1.0
        comment2.layer.cornerRadius = 10.0
        comment2.layer.masksToBounds = true
        comment2.delegate = self as! UITextViewDelegate
        var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
        let photoDir = self.documentDir + "/photo"
        do {
            try existFile = FileManager.default.contentsOfDirectory(atPath: photoDir) // Documents以下のファイルを取得
            let pngFile = color_label.text! + "_" + name_label.text! + ".png"
            let noImageFile = "noimage.png"
            var image: UIImage?
            if (existFile.index(of: pngFile) != nil) { // 写真がある場合
                image = UIImage(named: photoDir + "/" + pngFile)
                if ((image?.size.height)! / (image?.size.width)!) < 1.77 { // フルHDの比率じゃなかったら回転
                    image = image?.rotatedBy(degree: 90)
                }
            } else {
                image = UIImage(named: noImageFile)
            }
            imageView.contentMode = .scaleAspectFit
            //                let resizeImage = image?.resizeMaintainDirection(size:CGSize(width:94,height:345))
            self.imageView.image = image
        } catch {
            print ("error in viewDidLoad")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushBack(_ sender: Any) {
        var next = "recordTable"
        if delegate.view == "search" {
            next = "Top"
        }
        let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
//        delegate.view = "recordTable"
        let nextView = storyboard.instantiateViewController(withIdentifier:)(next) // UIViewControllerのクラスへ遷移する事を宣言
        self.present(nextView, animated: true, completion: nil) //画面の遷移
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
