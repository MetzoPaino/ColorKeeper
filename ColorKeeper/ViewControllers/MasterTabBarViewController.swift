//
//  MasterTabBarViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 15/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class MasterTabBarViewController: UITabBarController {

    var coreDataStack: CoreDataStack!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let colorList = self.viewControllers![0] as! ColorListViewController
//        colorList.coreDataStack = coreDataStack

        let flagViewController = self.viewControllers![0] as! LandingViewController
        flagViewController.coreDataStack = coreDataStack

        let colorList = self.viewControllers![1] as! ColorListViewController
        colorList.coreDataStack = coreDataStack


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
