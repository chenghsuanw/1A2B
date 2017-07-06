//
//  ViewController.swift
//  1A2B
//
//  Created by chenghsuan on 2017/6/23.
//  Copyright © 2017年 chenghsuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    let number = [0,1,2,3,4,5,6,7,8,9]
    var answer = [0,0,0,0]
    var input = [5,5,5,5]
    var chance = 10
    var pressHint = false
    var totalTime = 0
    var timer = Timer()
    var over = false
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var resultRecord: UITextView!
    @IBOutlet weak var chanceText: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hintBtn: UIButton!
    @IBOutlet weak var restartWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var restartHeightConstraint: NSLayoutConstraint!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.dataSource = self as UIPickerViewDataSource
        picker.delegate = self as UIPickerViewDelegate
        initial()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if over == true {
            over = false
            initial()
        }
    }
    
    func initial(){
        var nums = Array(0...9)
        for i in 0...3 {
            let index = Int(arc4random_uniform(UInt32(nums.count)))
            answer[i] = nums[index]
            nums.remove(at: index)
            ////
            print(answer[i])
        }
        chance = 10
        chanceText.text = "\(chance)"
        resultRecord.text = ""
        resultRecord.isHidden = true
        pressHint = false
        hintBtn.isEnabled = true
        timeLabel.text = "0:00"
        for i in 0...3 {
            picker.selectRow(5, inComponent: i, animated: true)
        }
        totalTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func hint(_ sender: Any) {
        pressHint = true
        hintBtn.isEnabled = false
        picker.selectRow(answer[0], inComponent: 0, animated: true)
        picker.selectRow(answer[2], inComponent: 2, animated: true)
    }
    
    @IBAction func record(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecordViewController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func restart(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "確定要重新開始嗎？", preferredStyle: .alert)
        let yes = UIAlertAction(title: "確定", style: .default, handler: {action in
            self.timer.invalidate()
            self.initial()
        })
        let no = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(yes)
        optionMenu.addAction(no)
        present(optionMenu, animated: true, completion: nil)
    }
    
    func legalInput(input:[Int])->Bool {
        for i in 0...2 {
            for j in i+1...3 {
                if input[i] == input[j] {
                    return false
                }
            }
        }
        return true
    }
    
    @IBAction func send(_ sender: Any) {
        for i in 0...3 {
            input[i] = Int((picker.delegate?.pickerView!(picker, titleForRow: picker.selectedRow(inComponent: i), forComponent: i))!)!
            if pressHint == true {
                if i == 1 || i == 3 {
                    picker.selectRow(5, inComponent: i, animated: true)
                }
                else {
                    picker.selectRow(answer[i], inComponent: i, animated: true)
                }
            }
            else {
                picker.selectRow(5, inComponent: i, animated: true)
            }
        }
        if legalInput(input: input) == false {
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
            resultRecord.isHidden = false
            resultRecord.scrollRangeToVisible(NSMakeRange(resultRecord.text.characters.count-1, 0))
            if acount != 4 {
                chance -= 1
                chanceText.text = "\(chance)"
            //lose
                if chance == 0 {
                    timer.invalidate()
                    over = true
                    addRecord(win: false, time: totalTime)
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                    controller.win = false
                    controller.time = totalTime
                    self.present(controller, animated: false, completion: nil)
                }
            }
            //win
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
    
    func updateTime(){
        totalTime += 1
        timeLabel.text = String(totalTime/60) + ":" + String(format: "%02d", totalTime%60)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(number[row])
        }
        else if component == 1 {
            return String(number[row])
        }
        else if component == 2 {
            return String(describing: number[row])
        }
        return String(describing: number[row])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

