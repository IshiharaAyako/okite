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
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = getTimeNow()
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        voiceAlert()
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
    
    func audiostop(){
        self.audioPlayer.stop()
        voice()
    }
    
    func alert(){
        let myAlert = UIAlertController(title: "朝ですよ〜！！", message: "", preferredStyle: .alert)
        let myOkAction = UIAlertAction(title: "起きる！", style: .default) {
            action in self.audiostop()
        }
        myAlert.addAction(myOkAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    func voiceAlert(){
        let voiceAlert = UIAlertController(title: "予定を追加しますか？", message: "", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "追加する", style: .default) {
            action in print("yes")
        }
        let NoAction = UIAlertAction(title: "追加しない", style: .default) {
            action in print("no")
        }
        voiceAlert.addAction(OkAction)
        present(voiceAlert, animated: true, completion: nil)
    }

    func voice() {
        /*SpeechSynthesizerクラス*/
        let talker = AVSpeechSynthesizer()
        // 話す内容をセット
        let utterance = AVSpeechUtterance(string: "今日の予定はhogehogeです。さぁ起きましょう")
        // 言語を日本に設定
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        // 実行
        talker.speak(utterance)
    }
}
