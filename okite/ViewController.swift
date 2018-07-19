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
    
    //追加
    var speechText: String = ""
    var speechText2: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = getTimeNow()
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
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
            let text = questionAlert.textFields![0].text!
            let text2 = questionAlert.textFields![1].text!
            self.speechText = text
            self.speechText2 = text2
            print("speechText = \(self.speechText)")
            print("speechText2 = \(self.speechText2)")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        questionAlert.addAction(speechAction)
        questionAlert.addAction(cancel)
        questionAlert.addTextField { (textField) in textField.placeholder = "first textField"}
        questionAlert.addTextField { (textField) in textField.placeholder = "second textField"}
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
        
        if speechText != "" {
            voice()
        }
    }
    
    func voice() {
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "今日の予定は\(speechText) \(speechText2)です。")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
        
        speechText = ""
        speechText2 = ""
    }
    
}


