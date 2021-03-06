//
//  ViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 12/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit
import CoreData

enum Sort {
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

class ColorListViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Variables
    let categorySort = NSSortDescriptor(key: #keyPath(Color.category), ascending: true)
    let favoriteSort = NSSortDescriptor(key: #keyPath(Color.favorite), ascending: false)
    let nameSort = NSSortDescriptor(key: #keyPath(Color.name), ascending: true)
    let cacheName = "colorLibrary"

    let searchController = UISearchController(searchResultsController: nil)

    var coreDataStack: CoreDataStack!
    var fetchedResultsController = NSFetchedResultsController<Color>()
    var sort = Sort.alphabetical

    var filterPredicate: NSPredicate? = nil

    lazy var sectionKeyPath: String = {
        #keyPath(Color.name)
    }()
    lazy var sortDescriptors: [NSSortDescriptor] = {
        [nameSort]
    }()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        setupSearchController()
        fetchedResultsController = setupFetchedResultsController()
        refreshData()
    }

    //MARK: - Setup
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func setupFetchedResultsController() -> NSFetchedResultsController<Color> {

        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: cacheName)

        let fetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = filterPredicate

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: sectionKeyPath,
            cacheName: cacheName)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }

    //MARK: - Internal
    func refreshData() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {

        if searchText.count < 1 {
            filterPredicate = nil
        } else {
            filterPredicate = NSPredicate(format:"name CONTAINS[cd] '\(searchText)' || category CONTAINS[cd] '\(searchText)' || hex CONTAINS[cd] '\(searchText)'")
        }

        fetchedResultsController = setupFetchedResultsController()
        refreshData()
        tableView.reloadData()
    }

    func sortResultsController(criteria: Sort) {

        switch criteria {
        case .alphabetical:
            sectionKeyPath = #keyPath(Color.name)
            sortDescriptors = [nameSort]
        case .category:
            sectionKeyPath = #keyPath(Color.category)
            sortDescriptors = [categorySort, nameSort]
        case .favorite:
            sectionKeyPath = #keyPath(Color.favorite)
            sortDescriptors = [favoriteSort, nameSort]
        }

        fetchedResultsController = setupFetchedResultsController()
        refreshData()
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SortSegue" {
            let popoverViewController = segue.destination as! SortTableViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
            popoverViewController.selectedSortCriteria = sort
        }
    }
}

//MARK: - UIPopoverPresentationControllerDelegate
extension ColorListViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

//MARK: - UITableViewDataSource
extension ColorListViewController: UITableViewDataSource {

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

        switch sort {
        case .alphabetical:
            return nil
        case .category:
            let sectionInfo = fetchedResultsController.sections?[section]
            return sectionInfo?.name
        case .favorite:
            let sectionInfo = fetchedResultsController.sections?[section]
            if sectionInfo?.name == "1" {
                return "Favorites"
            } else {
                return "Colors"
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension ColorListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let color = fetchedResultsController.object(at: indexPath)
        color.favorite = !color.favorite
        coreDataStack.saveContext()
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension ColorListViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard let indexPath = indexPath else {
            return
        }

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            let color = fetchedResultsController.object(at: indexPath)
            if let cell = tableView.cellForRow(at: indexPath) as? ColorTableViewCell {
                cell.configure(color: color)
            }
        case .move:
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension ColorListViewController: SortTableViewControllerDelegate {

    func sortSelected(sort: Sort) {
        self.sort = sort
        sortResultsController(criteria: sort)
        tableView.reloadData()
    }
}

//MARK: - UISearchResultsUpdatingDelegate
extension ColorListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
