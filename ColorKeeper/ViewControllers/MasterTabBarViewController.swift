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

        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                if let navigationController = viewController as? UINavigationController {

                    if let flagList = navigationController.topViewController as? FlagListViewController {

                        flagList.coreDataStack = coreDataStack
                    }

                    if let colorList = navigationController.topViewController as? ColorListViewController {

                        colorList.coreDataStack = coreDataStack
                    }
                }
            }
        }
    }
}
