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
    
    //追加-
    var speechText: String = ""
    //----
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = getTimeNow()
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
    }
    
    var audioPlayer:AVAudioPlayer!
    
    private var tmpTime: String = "00:00"
    private var setTime: String = "00:00"
    private var myTextField: UITextField! //追加
    
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
            //audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            alert()
        }
    }
    
    func alert(){
        let myAlert: UIAlertController = UIAlertController(title: "朝ですよ〜！！", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        let myOkAction: UIAlertAction = UIAlertAction(title: "起きる！", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.audioStop()
        })
        
        myAlert.addAction(myOkAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    func voice() {
        //        /*SpeechSynthesizerクラス*/
        //        let talker = AVSpeechSynthesizer()
        //        // 話す内容をセット
        //        let utterance = AVSpeechUtterance(string: "今日の予定は\(myTextField)です。さぁ起きましょう")
        //        //        let plan: String = "あああああああ"
        //        //        let utterance = AVSpeechUtterance(string: "今日の予定は\(plan)です。さぁ起きましょう")
        //        // 言語を日本に設定
        //        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        //        // 実行
        //        talker.speak(utterance)
        
        //追加
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "今日の予定は\(speechText)です。")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
    }
    
    func audioStop() {
        self.audioPlayer.stop()
        voice()
    }
    
    func setAlert(){
        let setAlert: UIAlertController = UIAlertController(title: "予定を追加しますか？", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "する", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            //self.planAlert()
            self.test()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "しない", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("no")
        })
        //UIAlertControllerにActionを追加
        setAlert.addAction(defaultAction)
        setAlert.addAction(cancelAction)
        //Alertを表示
        present(setAlert, animated: true, completion: nil)
    }
    
    func test() {
        let questionAlert = UIAlertController(title: "今日の予定は？", message: "", preferredStyle: .alert)
        questionAlert.addTextField(configurationHandler: { (textField:UITextField) -> Void in
            textField.placeholder = "placeholder"
        })
        
        //        questionAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) -> Void in
        //        let textField = questionAlert.textFields![0] as UITextField
        //        print("Text field: \(String(describing: textField.text))")
        //        }))
        //
        //        questionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction) -> Void in
        //        print("Text field: cancel")
        //        }))
        //        self.present(questionAlert, animated: true, completion: nil)
        
        //追加
        let speechAction = UIAlertAction(title: "OK", style: .default, handler: { (_) -> Void in
            // TextFieldから値を取得
            if let text = questionAlert.textFields?.first?.text {
                self.speechText = text
                //self.voice()
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        questionAlert.addAction(speechAction)
        questionAlert.addAction(cancel)
        questionAlert.addTextField { (textField) in }
        present(questionAlert, animated: true, completion: nil)
    }
}


