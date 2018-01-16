//
//  MasterTabBarViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 15/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class MasterTabBarViewController: UITabBarController {

    //MARK: - Variables
    var coreDataStack: CoreDataStack!

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        for viewController in viewControllers! {

//            if viewController is FlagListViewController {
//                (viewController as! FlagListViewController).coreDataStack = coreDataStack
//            }

            if viewController is UINavigationController {

                if let flagList = (viewController as! UINavigationController).topViewController as? FlagListViewController {

                    flagList.coreDataStack = coreDataStack
                }

                if let colorList = (viewController as! UINavigationController).topViewController as? ColorListViewController {

                    colorList.coreDataStack = coreDataStack
                }
            }
        }
    }
}
