//
//  ViewController.swift
//  okite
//
//  Created by 石原 理子 on 2018/07/09.
//  Copyright © 2018年 石原 理子. All rights reserved.
//

import UIKit
import AudioToolbox //追加
import AVFoundation //AVFoundationのインポート

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timeLabel.text = getTimeNow()
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //audioPlayerを作成
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
            //アラーム
            //        var soundIdRing:SystemSoundID = 0
            //        if let soundUrl:NSURL = NSURL(fileURLWithPath:
            //            Bundle.main.path(forResource: "Clock-Alarm Dig01-2L", ofType:"mp3")!) as NSURL?{
            //            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            //            AudioServicesPlaySystemSound(soundIdRing)
            //        }
            
            // 追加
            //playSound(name: "Clock-Alarm Dig01-2L")
            
            // 再生する audio ファイルのパスを取得
            let audioPath = Bundle.main.path(forResource: "Clock-Alarm Dig01-2L", ofType:"mp3")!
            let audioUrl = URL(fileURLWithPath: audioPath)
            
            // auido を再生するプレイヤーを作成する
            var audioError:NSError?
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
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
            //---
            alert()
        }
    }
    
    func test(){
        print("Pushed Button")
        //self.audioPlayer.stop()
        audioPlayer.stop()
    }
    
    func alert(){
        //アラート表示
        let myAlert = UIAlertController(title: "朝ですよ〜！！", message: "", preferredStyle: .alert)
        let myOkAction = UIAlertAction(title: "OK", style: .default) {
            //action in self.audioPlayer.stop()
            action in self.test()
        }
        myAlert.addAction(myOkAction)
        present(myAlert, animated: true, completion: nil)
    }
    
}

//extension ViewController: AVAudioPlayerDelegate {
//    func playSound(name: String) {
//        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
//            print("音源ファイルが見つかりません")
//            return
//        }
//        do {
//            // AVAudioPlayerのインスタンス化
//            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
//
//            // AVAudioPlayerのデリゲートをセット
//            audioPlayer.delegate = self
//
//            // 音声の再生
//            audioPlayer.play()
//        } catch {
//        }
//    }
//}
//
//
