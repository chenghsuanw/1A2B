//
//  RecordViewController.swift
//  1A2B
//
//  Created by chenghsuan on 2017/6/30.
//  Copyright © 2017年 chenghsuan. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var gameCountLabel: UILabel!
    @IBOutlet weak var winCountLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var bestTimeLabel: UILabel!
    @IBOutlet weak var aveTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getRecord()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRecord(){
        let userDefault = UserDefaults.standard
        let gameCount = userDefault.integer(forKey: "gameCount")
        let winCount = userDefault.integer(forKey: "winCount")
        let bestTime = userDefault.integer(forKey: "bestTime")
        let totalTime = userDefault.integer(forKey: "totalTime")
        gameCountLabel.text = String(gameCount)
        winCountLabel.text = String(winCount)
        if gameCount == 0 {
            winRateLabel.text = "0%"
        }
        else {
            winRateLabel.text = String(format: "%.2f", Float(winCount)/Float(gameCount)*100) + "%"
        }
        bestTimeLabel.text = "\(bestTime/60)m\(bestTime%60)s"
        aveTimeLabel.text = "\(totalTime/60)m\(totalTime%60)s"
    }

    @IBAction func clear(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "確定要清除記錄嗎？", preferredStyle: .alert)
        let yes = UIAlertAction(title: "確定", style: .default, handler: {
            action in self.clearUserdefault()
        })
        let no = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(yes)
        optionMenu.addAction(no)
        present(optionMenu, animated: true, completion: nil)
    }
    func clearUserdefault(){
        let userDefault = UserDefaults.standard
        userDefault.set(0, forKey: "gameCount")
        userDefault.set(0, forKey: "winCount")
        userDefault.set(0, forKey: "bestTime")
        userDefault.set(0, forKey: "totalTime")
        getRecord()
    }
    @IBAction func `return`(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
