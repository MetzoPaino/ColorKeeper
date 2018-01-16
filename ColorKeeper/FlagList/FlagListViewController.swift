//
//  LandingViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 14/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit
import CoreData

class FlagListViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK: - Variables
    var coreDataStack: CoreDataStack!

    lazy var fetchedResultsController: NSFetchedResultsController<Flag> = {
        let fetchRequest: NSFetchRequest<Flag> = Flag.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(Flag.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: "Flags")

        return fetchedResultsController
    }()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }

        setupCollectionView()
    }

    func setupCollectionView() {

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FlagDetailViewController {

            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                controller.flag = fetchedResultsController.object(at: indexPath)
            } else {
                controller.flag = Flag()
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension FlagListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return fetchedObjects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FlagCollectionViewCell else {
            return UICollectionViewCell()
        }

        let flag = fetchedResultsController.object(at: indexPath)
        cell.configure(flag: flag)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension FlagListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PushFlagDetail", sender: self)
    }
}
