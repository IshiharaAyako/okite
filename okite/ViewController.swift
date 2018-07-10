//
//  ViewController.swift
//  okite
//
//  Created by 石原 理子 on 2018/07/09.
//  Copyright © 2018年 石原 理子. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timeLabel.text = getTimeNow()
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        //日付
        dateFormater.dateStyle = .short
        let date = dateFormater.string(from: Date())
        print("date:" + date)
        dateLabel.text = date
        //時間
        dateFormater.timeStyle = .short
        dateFormater.dateStyle = .none
        let time = dateFormater.string(from: Date())
        print("time:", time)
        timeLabel.text = time
        
//        //nowTimeの確認
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let nowTime = formatter.string(from: Date())
//        print("nowTime:" + nowTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var tempTime: String = "00:00"
    private var setTime: String = "00:00"
//    private var nowTime: String = "00:00"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerFunc(_ sender: AnyObject) {
        // DPの値を成形
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        // 一時的にDPの値を保持
        tempTime = dateFormater.string(from: datePicker.date)
    }
    
    @IBAction func buttonFunc(_ sender: AnyObject) {
        setTime = tempTime
        print("setTime:" + setTime)
    }
    
    func getTimeNow()-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let nowTime = formatter.string(from: Date())
        return nowTime
        
        
//        // 現在時刻を取得
//        let nowTime: Date = Date()
//        // 成形する
//        let format = DateFormatter()
//        format.dateFormat = "HH:mm"
//        let nowTimeStr = format.string(from: nowTime)
//        print("ok")
//        // 成形した時刻を文字列として返す
//        return nowTimeStr
    }
    
    func update() {
        // 現在時刻を取得
        let str = getTimeNow()
        // アラーム鳴らすか判断
        Alarm(str: str)
    }
    
    func Alarm(str: String) {
        if (str == setTime){
            print("ok")
        }
    }
    
}


