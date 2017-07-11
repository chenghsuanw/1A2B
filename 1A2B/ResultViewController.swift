//
//  ResultViewController.swift
//  1A2B
//
//  Created by chenghsuan on 2017/7/6.
//  Copyright © 2017年 chenghsuan. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    var win:Bool?
    var time:Int?
    var answer:[Int]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if win! == true {
            resultImage.image = UIImage(named: "win")
            let bestTime = UserDefaults.standard.integer(forKey: "bestTime")
            resultLabel.text = "本次時間：" + String(time!/60) + ":" + String(format: "%02d", time!%60) + "\n最佳時間：" + String(bestTime/60) + ":" + String(format: "%02d", bestTime%60)
        }
        else {
            resultImage.image = UIImage(named: "lose")
            resultLabel.text = "正確答案：\(answer![0])\(answer![1])\(answer![2])\(answer![3])"
        }
    }

    @IBAction func restart(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "確定要重新開始嗎？", preferredStyle: .alert)
        let yes = UIAlertAction(title: "確定", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        let no = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(no)
        optionMenu.addAction(yes)
        let controller = presentingViewController as! ViewController
        present(optionMenu, animated: true, completion: controller.timerStart)
    }
    
    @IBAction func record(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RecordViewController")
        self.present(controller!, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
