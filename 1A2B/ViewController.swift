//
//  ViewController.swift
//  1A2B
//
//  Created by chenghsuan on 2017/6/23.
//  Copyright © 2017年 chenghsuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    let number = [0,1,2,3,4,5,6,7,8,9]
    var answer = [0,0,0,0]
    var input:[Int] = []
    var chance = 10
    var totalTime = 0
    var timer = Timer()
    var over = false
    var pressRule = false
    @IBOutlet weak var resultRecord: UITextView!
    @IBOutlet weak var chanceText: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet var numberButtons: [UIButton]!
    
    func timerStart(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        if UserDefaults.standard.bool(forKey: "hasViewRule") {
            timerStart()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if over == true {
            over = false
            initial()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewRule") {
            return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "RuleController") as? RulePageViewController {
            present(pageViewController, animated: false, completion: initial)
        }
    }
    
    
    func initial(){
        var nums = Array(0...9)
        for i in 0...3 {
            let index = Int(arc4random_uniform(UInt32(nums.count)))
            answer[i] = nums[index]
            nums.remove(at: index)
        }
        while !input.isEmpty {
            let letter = input.popLast()
            numberButtons[letter!].isEnabled = true
            let index = inputLabel.text?.index(inputLabel.text!.startIndex, offsetBy: input.count*3)
            inputLabel.text?.remove(at: index!)
            inputLabel.text?.insert("＿", at: index!)
        }
        chance = 10
        chanceText.text = "\(chance)"
        resultRecord.text = ""
        timeLabel.text = "0:00"
        totalTime = 0
    }
    @IBAction func pressButton(_ sender: UIButton) {
        if input.count < 4 {
            sender.isEnabled = false
            sender.setTitleColor(UIColor.gray, for: .normal)
            let index = inputLabel.text?.index(inputLabel.text!.startIndex, offsetBy: input.count*3)
            inputLabel.text?.remove(at: index!)
            inputLabel.text?.insert(Character(sender.title(for: .normal)!), at: index!)
            input.append(Int(sender.title(for: .normal)!)!)
        }
    }
    
    @IBAction func deleteNumber(_ sender: Any) {
        if !input.isEmpty {
            let letter = input.popLast()
            numberButtons[letter!].isEnabled = true
            numberButtons[letter!].setTitleColor(UIColor.black, for: .normal)
            let index = inputLabel.text?.index(inputLabel.text!.startIndex, offsetBy: input.count*3)
            inputLabel.text?.remove(at: index!)
            inputLabel.text?.insert("＿", at: index!)
        }
    }

    @IBAction func list(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ruleAction = UIAlertAction(title: "規則", style: .default, handler: {action in
            self.rule()
        })
        let restartAction = UIAlertAction(title: "重新", style: .default, handler: {action in
            self.restart()
        })
        let recordAction = UIAlertAction(title: "紀錄", style: .default, handler: {action in
            self.record()
        })
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(ruleAction)
        optionMenu.addAction(restartAction)
        optionMenu.addAction(recordAction)
        optionMenu.addAction(cancel)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func rule(){
        pressRule = true
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "RuleController") as? RulePageViewController {
            timer.invalidate()
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    func restart(){
        let optionMenu = UIAlertController(title: nil, message: "確定要重新開始嗎？", preferredStyle: .alert)
        let yes = UIAlertAction(title: "確定", style: .default, handler: {action in
            self.timer.invalidate()
            self.initial()
            self.timerStart()
        })
        let no = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(yes)
        optionMenu.addAction(no)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func record(){
        self.timer.invalidate()
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecordViewController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    
    @IBAction func send(_ sender: Any) {
        if input.count != 4 {
            let optionMenu = UIAlertController(title: nil, message: "請輸入4個不同的數字", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            present(optionMenu, animated: true, completion: nil)
        }
        else {
            var acount = 0
            var bcount = 0
            for i in 0...3 {
                for j in 0...3 {
                    if answer[i] == input[j] {
                        if i == j {
                            acount += 1
                        }
                        else {
                            bcount += 1
                        }
                        break
                    }
                }
            }
            resultRecord.text! += "\(input[0])\(input[1])\(input[2])\(input[3])\t\t\(acount)A\(bcount)B\n"
            resultRecord.font = UIFont.systemFont(ofSize: 20)
            resultRecord.scrollRangeToVisible(NSMakeRange(resultRecord.text.characters.count-1, 0))
            while !input.isEmpty {
                let letter = input.popLast()
                numberButtons[letter!].isEnabled = true
                let index = inputLabel.text?.index(inputLabel.text!.startIndex, offsetBy: input.count*3)
                inputLabel.text?.remove(at: index!)
                inputLabel.text?.insert("＿", at: index!)
            }
            if acount != 4 {
                chance -= 1
                chanceText.text = "\(chance)"
                if chance == 0 {
                    timer.invalidate()
                    over = true
                    addRecord(win: false, time: totalTime)
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                    controller.win = false
                    controller.time = totalTime
                    controller.answer = self.answer
                    self.present(controller, animated: false, completion: nil)
                }
            }
            else {
                timer.invalidate()
                over = true
                addRecord(win: true, time: totalTime)
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                controller.win = true
                controller.time = totalTime
                self.present(controller, animated: false, completion: nil)
            }
        }
    }

    func addRecord(win:Bool, time:Int){
        let userDefault = UserDefaults.standard
        var gameCount = userDefault.integer(forKey: "gameCount")
        gameCount += 1
        userDefault.set(gameCount, forKey: "gameCount")
        if win == true {
            var winCount = userDefault.integer(forKey: "winCount")
            var totalTime = userDefault.integer(forKey: "totalTime")
            var bestTime = userDefault.integer(forKey: "bestTime")
            winCount += 1
            totalTime += time
            if bestTime == 0 || time < bestTime {
                bestTime = time
            }
            userDefault.set(winCount, forKey: "winCount")
            userDefault.set(totalTime, forKey: "totalTime")
            userDefault.set(bestTime, forKey: "bestTime")
        }
        userDefault.synchronize()
    }
    
    func continueOrRestart(){
        let optionMenu = UIAlertController(title: nil, message: "要重新開始或是繼續遊戲？", preferredStyle: .alert)
        let conti = UIAlertAction(title: "繼續遊戲", style: .cancel, handler: {action in
            self.timerStart()
        })
        let restart = UIAlertAction(title: "重新開始", style: .default, handler: {action in
            self.initial()
            self.timerStart()
        })
        optionMenu.addAction(conti)
        optionMenu.addAction(restart)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func updateTime(){
        totalTime += 1
        timeLabel.text = String(totalTime/60) + ":" + String(format: "%02d", totalTime%60)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

