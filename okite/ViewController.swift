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
        // 起動した時点の時刻をmyLabelに反映
        timeLabel.text = getTimeNow()
        // 60秒ごとにupdate()を呼び出す
        update()
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var tempTime: String = "00:00"
    private var setTime: String = "00:00"
    
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
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        //日付
        dateFormater.dateStyle = .short
        let date = dateFormater.string(from: Date())
        dateLabel.text = date
        //時間
        dateFormater.timeStyle = .short
        dateFormater.dateStyle = .none
        let time = dateFormater.string(from: Date())
        timeLabel.text = time
        return time
    }
    
    @objc func update() {
        // 現在時刻を取得
        let str = getTimeNow()
        // アラーム鳴らすか判断
        Alarm(str: str)
    }
    
    func Alarm(str: String) {
        if (str == setTime){
            alert()
        }
    }
    
    func alert(){
        // UIAlertControllerを作成する.
        //let myAlert: UIAlertController = UIAlertController(title: "朝ですよ〜！！", message: "", preferredStyle: .alert)
        let myAlert = UIAlertController(title: "朝ですよ〜！！", message: "", preferredStyle: .alert)
        // OKのアクションを作成する.
        let myOkAction = UIAlertAction(title: "OK", style: .default) {
            action in print("Action OK!!")
        }
        // OKのActionを追加する
        myAlert.addAction(myOkAction)
        // UIAlertを発動する.
        present(myAlert, animated: true, completion: nil)
        
    }
    
}


