//
//  ViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 12/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit
import CoreData

enum Filter {
    case alphabetical
    case category
    case favorite

    var stringValue: String {
        switch self {
        case .alphabetical:
            return "A - Z"
        case .category:
            return "Group"
        case .favorite:
            return "Fav"
        }
    }
}

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var coreDataStack: CoreDataStack!
    var filter = Filter.alphabetical

    lazy var fetchedResultsController: NSFetchedResultsController<Color> = {
        let fetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
        let zoneSort = NSSortDescriptor(key: #keyPath(Color.category), ascending: true)
        let scoreSort = NSSortDescriptor(key: #keyPath(Color.favorite), ascending: false)
        let nameSort = NSSortDescriptor(key: #keyPath(Color.name), ascending: true)

        switch filter {
            case .alphabetical:
                fetchRequest.sortDescriptors = [nameSort]
            default:
                fetchRequest.sortDescriptors = [zoneSort, nameSort]
        }


        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: #keyPath(Color.category),
            cacheName: "colorLibrary")

        fetchedResultsController.delegate = self

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
    }

    func sortResultsController(criteria: Filter) {

        let zoneSort = NSSortDescriptor(key: #keyPath(Color.category), ascending: true)
        //let scoreSort = NSSortDescriptor(key: #keyPath(Color.favorite), ascending: false)
        let nameSort = NSSortDescriptor(key: #keyPath(Color.name), ascending: true)

        switch criteria {
        case .alphabetical:
            fetchedResultsController.fetchRequest.sortDescriptors = [nameSort]
        default:
            fetchedResultsController.fetchRequest.sortDescriptors = [zoneSort, nameSort]
        }

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ColorTableViewCell else {
            return UITableViewCell()
        }

        let color = fetchedResultsController.object(at: indexPath)
        cell.configure(color:color)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch filter {
        case .alphabetical:
            return nil
        default:
            let sectionInfo = fetchedResultsController.sections?[section]
            return sectionInfo?.name
        }
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = fetchedResultsController.object(at: indexPath)
        team.favorite = !team.favorite
        coreDataStack.saveContext()
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .update:
            let color = fetchedResultsController.object(at: indexPath!)
            let cell = tableView.cellForRow(at: indexPath!) as! ColorTableViewCell
            cell.configure(color: color)
        case .move, .delete, .insert:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterSegue" {
            let popoverViewController = segue.destination as! FilterTableViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
        }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension ViewController: FilterTableViewControllerDelegate {

    func filterSelected(filter: Filter) {

        sortResultsController(criteria: filter)
        self.filter = filter
        tableView.reloadData()
    }
}

