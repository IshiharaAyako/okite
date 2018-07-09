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
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm"
        let date = dateFormater.string(from: Date())
        
        
        //print(date)     // 2017/04/04 10:44
        Label.text = date
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var date_picker: UIDatePicker!
    
    @IBAction func date_picker_func(_ sender: AnyObject) {
        print("test: myDP moved!")
    }    
    @IBAction func button_func(_ sender: AnyObject) {
        print("test: myButton Pushed!")
    }
}


