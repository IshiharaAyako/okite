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
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        //日付
        dateFormater.dateStyle = .short
        let date = dateFormater.string(from: Date())
        print("date:" + date)
        dateLabel.text = date
        //追加
//        //dateLabel.sizeToFit()
//        dateLabel.center = self.view.center
//        dateLabel.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
//        //dateLabel.backgroundColor = UIColor.gray

        //時間
        dateFormater.timeStyle = .short
        dateFormater.dateStyle = .none
        let time = dateFormater.string(from: Date())
        print("time:", time)
        timeLabel.text = time
        //追加
//        //dateLabel.sizeToFit()
//        //timeLabel.center = self.view.center
//        timeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
//        timeLabel.backgroundColor = UIColor.blue
//        timeLabel.layer.position = CGPoint(x: 100, y: 100);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerFunc(_ sender: AnyObject) {
        print("test: dataPickerFunc moved!")
    }
    
    @IBAction func buttonFunc(_ sender: AnyObject) {
        print("test: buttonFunc Pushed!")
    }
    
}


