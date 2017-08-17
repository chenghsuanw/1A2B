//
//  RuleContentViewController.swift
//  1A2B
//
//  Created by chenghsuan on 2017/7/10.
//  Copyright © 2017年 chenghsuan. All rights reserved.
//

import UIKit

class RuleContentViewController: UIViewController {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    var index = 0
    var firstLabelText = ""
    var secondLabelText = ""
    var thirdLabelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLabel.text = firstLabelText
        secondLabel.text = secondLabelText
        thirdLabel.text = thirdLabelText
        pageControl.currentPage = index
        if index == 3 {
            thirdLabel.isHidden = true
            startButton.isHidden = false
            returnButton.isHidden = true
        }
        else {
            startButton.isHidden = true
            if UserDefaults.standard.bool(forKey: "hasViewRule") && index == 0 {
                returnButton.isHidden = false
            }
            else {
                returnButton.isHidden = true
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasViewRule")
        let controller = presentingViewController as! ViewController
        if controller.pressRule == false {
            dismiss(animated: true, completion: controller.timerStart)
        }
        else {
            dismiss(animated: true, completion: controller.continueOrRestart)
        }
    }
    
    @IBAction func `return`(_ sender: Any) {
        let controller = presentingViewController as! ViewController
        dismiss(animated: true, completion: controller.continueOrRestart)
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
