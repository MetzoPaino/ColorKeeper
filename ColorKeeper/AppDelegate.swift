//
//  AppDelegate.swift
//  ColorKeeper
//
//  Created by William Robinson on 12/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "ColorLibrary")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        importJSONDataIfNeeded()

        guard let navController = window?.rootViewController as? UINavigationController,
            let viewController = navController.topViewController as? MasterTabBarViewController else {
                return true
        }

        viewController.coreDataStack = coreDataStack
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}

extension AppDelegate {

    func importJSONDataIfNeeded() {

        let colorFetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
        let flagFetchRequest: NSFetchRequest<Flag> = Flag.fetchRequest()

        let colorCount = try? coreDataStack.managedContext.count(for: colorFetchRequest)
        let flagCount = try? coreDataStack.managedContext.count(for: flagFetchRequest)

        if let colorCount = colorCount, colorCount == 0 {
            importJSONColorData()
        }

        if let flagCount = flagCount, flagCount == 0 {
            importJSONFlagData()
        }
       
    }

    func importJSONColorData() {

        let jsonURL = Bundle.main.url(forResource: "colors", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonURL)

        do {
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [[String: Any]]

            for jsonDictionary in jsonArray {
                let name = jsonDictionary["name"] as! String
                let category = jsonDictionary["category"] as! String
                let hex = jsonDictionary["hex"] as! String
                let favorite = jsonDictionary["favorite"] as! Bool

                let color = Color(context: coreDataStack.managedContext)
                color.name = name
                color.hex = hex
                color.category = category
                color.favorite = favorite
            }

            coreDataStack.saveContext()

        } catch let error as NSError {
            print("Error importing colors: \(error)")
        }
    }

    func importJSONFlagData() {

        let jsonURL = Bundle.main.url(forResource: "flags", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonURL)

        do {
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [[String: Any]]

            for jsonDictionary in jsonArray {
                let name = jsonDictionary["name"] as! String
                let componentColorNamesArray = jsonDictionary["colors"] as! [Dictionary<String, String>]

                var predicateArray = [NSPredicate]()

                for componentColorNameDictionary in componentColorNamesArray {

                    if let componentColorName = componentColorNameDictionary["name"] {
                        predicateArray.append( NSPredicate(format:"name MATCHES[cd] '\(componentColorName)'"))
                    }
                }

                let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicateArray)
                let flag = Flag(context: coreDataStack.managedContext)
                flag.name = name

                let fetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Color.name), ascending: true)]
                fetchRequest.predicate = compoundPredicate

                let fetchedResultsController = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: coreDataStack.managedContext,
                    sectionNameKeyPath: nil,
                    cacheName: nil)

                do {
                    try fetchedResultsController.performFetch()
                } catch let error as NSError {
                    print("Fetching error: \(error), \(error.userInfo)")
                }

                guard let array = fetchedResultsController.fetchedObjects else {
//                    flag.colors = NSSet()
                    flag.colors = NSOrderedSet()
                    return
                }


                for color in array {
                    flag.addToColors(color)
//                    flag.add
                }

//                flag.colors = NSOrderedSet(array: array)

                print(flag.colors?.array)
                do {
                    try flag.managedObjectContext?.save()
                } catch let error as NSError {
                    print("saving error: \(error), \(error.userInfo)")
                }

            }

            coreDataStack.saveContext()

        } catch let error as NSError {
            print("Error importing flags: \(error)")
        }
    }
}

extension AppDelegate {



}
