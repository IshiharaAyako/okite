//
//  ViewController.swift
//  okite
//
//  Created by 石原 理子 on 2018/07/09.
//  Copyright © 2018年 石原 理子. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var speechText1: String = ""
    var speechText2: String = ""
    var speechText3: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = getTimeNow()
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
        
        //グラデーションレイヤーをスクリーンサイズにする
        gradationLayer.frame = self.view.bounds
        
        // グラデーションをViewに追加
        view.layer.insertSublayer(gradationLayer, at: 0)
    }
    
    var audioPlayer:AVAudioPlayer!
    
    private var tmpTime: String = "00:00"
    private var setTime: String = "00:00"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerFunc(_ sender: AnyObject) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        tmpTime = dateFormater.string(from: datePicker.date)
    }
    
    @IBAction func buttonFunc(_ sender: AnyObject) {
        setTime = tmpTime
        print("setTime:" + setTime)
        setAlert()
    }
    
    //背景グラデーション
    var gradationLayer:CALayer = {
        let gradientLayer = CAGradientLayer()
        // グラデーションの方向
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        // 色が切り替わる地点
        let locations:[NSNumber] = [0.0, 0.555, 0.875]
        gradientLayer.locations = locations
        
        //グラデーションの開始色
        let topColor = UIColor(red:0.675, green:0.878, blue:0.976, alpha:1)
        //グラデーションの開始色
        let centerColor = UIColor(red:0.761, green:0.894, blue:0.961, alpha:1)
        //グラデーションの開始色
        let bottomColor = UIColor(red:1.0, green:0.945, blue:0.922, alpha:1)
        // 切り替わる色
        let colors = [topColor.cgColor, centerColor.cgColor, bottomColor.cgColor]
        gradientLayer.colors = colors
        return gradientLayer
    }()
    
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
        print("time:" + time)
        return time
    }
    
    @objc func timeUpdate() {
        let str = getTimeNow()
        alarm(str: str)
    }
    
    func setAlert(){
        let setAlert: UIAlertController = UIAlertController(title: "予定を追加しますか？", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "する", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.planAlert()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "しない", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("予定を追加していません")
        })
        
        //UIAlertControllerにActionを追加
        setAlert.addAction(defaultAction)
        setAlert.addAction(cancelAction)
        //Alertを表示
        present(setAlert, animated: true, completion: nil)
    }
    
    func planAlert() {
        let questionAlert = UIAlertController(title: "明日の予定は？", message: "", preferredStyle: .alert)
        let speechAction = UIAlertAction(title: "OK", style: .default, handler: { (_) -> Void in
            let text1 = questionAlert.textFields![0].text!
            let text2 = questionAlert.textFields![1].text!
            let text3 = questionAlert.textFields![2].text!
            self.speechText1 = text1
            self.speechText2 = text2
            self.speechText3 = text3
            print("speechText1 = \(self.speechText1)")
            print("speechText2 = \(self.speechText2)")
            print("speechText3 = \(self.speechText3)")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        questionAlert.addAction(speechAction)
        questionAlert.addAction(cancel)
        questionAlert.addTextField { (textField) in }
        questionAlert.addTextField { (textField) in }
        questionAlert.addTextField { (textField) in }
        present(questionAlert, animated: true, completion: nil)
    }
    
    func alarm(str: String) {
        if (str == setTime){
            // 再生する audio ファイルのパスを取得
            let audioPath = Bundle.main.path(forResource: "Clock-Alarm Dig01-2L", ofType:"mp3")!
            let audioUrl = URL(fileURLWithPath: audioPath)
            // auidoを再生するプレイヤーを作成する
            var audioError:NSError?
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
                audioPlayer?.numberOfLoops = -1
            } catch let error as NSError {
                audioError = error
                audioPlayer = nil
            }
            // エラーが起きたとき
            if let error = audioError {
                print("Error \(error.localizedDescription)")
            }
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            alert()
        }
    }
    
    func alert(){
        let myAlert: UIAlertController = UIAlertController(title: "おきて〜！！", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        let myOkAction: UIAlertAction = UIAlertAction(title: "STOP", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.audioStop()
        })
        
        myAlert.addAction(myOkAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    func audioStop() {
        self.audioPlayer.stop()
        
        if speechText1 != "" {
            voice()
        }
    }
    
    func voice() {
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "おはようございます。今日の予定は\(speechText1)。 +  。 + \(speechText2)。 +  。 + \(speechText3)。です。")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.pitchMultiplier = 1.2
        talker.speak(utterance)
        
        speechText1 = ""
        speechText2 = ""
        speechText3 = ""
    }
    
}


