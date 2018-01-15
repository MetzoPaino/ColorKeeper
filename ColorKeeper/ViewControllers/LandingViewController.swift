//
//  LandingViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 14/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit
import CoreData

class LandingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

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

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if let controller = segue.destination as? FlagDetailViewController {

            controller.flag = fetchedResultsController.object(at: IndexPath(item: 0, section: 0))
        }

        if let controller = segue.destination as? ColorListViewController {

            controller.coreDataStack = coreDataStack
        }
        
    }



}

// MARK: - UICollectionViewDataSource
extension LandingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return fetchedObjects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! FlagCollectionViewCell
        let flag = fetchedResultsController.object(at: indexPath)
        
        cell.configure(flag: flag)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LandingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PushFlagDetail", sender: self)

//        self.performSegue(withIdentifier: "PushColorList", sender: self)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension LandingViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .automatic)
//        case .update:
//            let cell = tableView.cellForRow(at: indexPath!) as! TeamCell
//            configure(cell: cell, for: indexPath!)
//        case .move:
//            tableView.deleteRows(at: [indexPath!], with: .automatic)
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//        let indexSet = IndexSet(integer: sectionIndex)
//
//        switch type {
//        case .insert:
//            tableView.insertSections(indexSet, with: .automatic)
//        case .delete:
//            tableView.deleteSections(indexSet, with: .automatic)
//        default: break
//        }
    }
}
