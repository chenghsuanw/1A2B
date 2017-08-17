//
//  RulePageViewController.swift
//  1A2B
//
//  Created by chenghsuan on 2017/7/10.
//  Copyright © 2017年 chenghsuan. All rights reserved.
//

import UIKit

class RulePageViewController: UIPageViewController, UIPageViewControllerDataSource {

    let label1Text = ["每一回合都會有一組密碼，密碼為4個不重複的數字，你必須在炸彈爆炸前找到密碼","如果你輸入的數字與密碼相同且在同樣的位置，你會得到一個A","如果你的輸入與密碼相同但在不同位置，你會得到一個B","在炸彈爆炸前總共有10次機會，並擁有1次提示的機會，祝你好運！"]
    let label2Text = ["首先，需要先選擇4個數字","在這個例子中，你會得到1A0B","在這個例子中，你會得到0A2B",""]
    let label3Text = ["有效輸入：1234\n無效輸入：2266","你的輸入：1234\n正確密碼：5674","你的輸入：1234\n正確密碼：4829",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contentViewController(at index: Int) -> RuleContentViewController? {
        if index < 0 || index >= label1Text.count {
            return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "RuleContentViewController") as? RuleContentViewController {
            pageContentViewController.firstLabelText = label1Text[index]
            pageContentViewController.secondLabelText = label2Text[index]
            pageContentViewController.thirdLabelText = label3Text[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! RuleContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! RuleContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
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
