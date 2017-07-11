//
//  testViewController.swift
//  1A2B
//
//  Created by chenghsuan on 2017/7/9.
//  Copyright © 2017年 chenghsuan. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBAction func plus(_ sender: Any) {
        pagecontrol.currentPage += 1
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBAction func change(_ sender: Any) {
        self.label.text = "\(self.pagecontrol.currentPage)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
