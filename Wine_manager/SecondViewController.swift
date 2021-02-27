//
//  SecondViewController.swift
//  Wine_manager
//
//  Created by Hiroya Kato on 2018/07/25.
//  Copyright © 2018年 Hiroya Kato. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class SecondViewController:
UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    var selectDay: (Int,Int,Int)?
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var documentDir: String = ""
    var existFile: [String] = [] // Documents以下に存在するファイルを格納する変数
    var datesWithEvent: [String] = []
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.documentDir = NSHomeDirectory() + "/Documents/date/"
        do {
            try existFile = FileManager.default.contentsOfDirectory(atPath: documentDir) // Documents以下のファイルを取得
            for i in 0..<existFile.count {
                if let range = existFile[i].range(of: ".csv") {
                    existFile[i].removeSubrange(range) // .csvを削除
                    var tmp = existFile[i]
                    print (tmp)
                    var ST1 = tmp.index(tmp.startIndex, offsetBy:4)
                    print (ST1)
                    tmp.insert("-", at: ST1)
                    ST1 = tmp.index(tmp.startIndex, offsetBy:7)
                    tmp.insert("-", at: ST1)
                    datesWithEvent.append(tmp)
                }
            }
            print (datesWithEvent)
        } catch {
            print ("error")
        }       // デリゲートの設定
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let RegistrationViewController = segue.destination as! RegistrationViewController
     RegistrationViewController.next = selectDay as? String
     }
     */
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday,from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        // let reg = AppDelegate()
        selectDay = getDay(date)
        delegate.message = selectDay
        delegate.view = "record"
        let storyboard: UIStoryboard = self.storyboard! // 遷移先が自身のStoryboardであることを宣言
        let nextView = storyboard.instantiateViewController(withIdentifier:)("recordTable") // UIViewControllerのクラスへ遷移する事を宣言
        self.present(nextView, animated: true, completion: nil) //画面の遷移
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
}

