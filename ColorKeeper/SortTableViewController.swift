//
//  FilterTableViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 13/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

enum OrganiseType {
    case filter
    case sort

    var stringValue: String {
        switch self {
        case .filter:
            return "Filter"
        case .sort:
            return "Sort"
        }
    }

    var arrayValues: [Sort] {

        switch self {
        case .filter:
            return [.favorite]
        case .sort:
            return [Sort.alphabetical, .category, .favorite]
        }
    }
}

protocol SortTableViewControllerDelegate: class {
    func sortSelected(sort: Sort)
    func filterSelected(sort: Sort)

}

class SortTableViewController: UITableViewController {

    //MARK: - Variables

    let sortCriteria = [Sort.alphabetical, .category, .favorite]

    weak var delegate: SortTableViewControllerDelegate?

    lazy var selectedSortCriteria: Sort = {
        Sort.alphabetical
    }()
    lazy var filterCriteria: [String] = {
        []
    }()

    var organiseType: OrganiseType = OrganiseType.sort

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false;
        tableView.tableFooterView = UIView()

        switch organiseType {
        case .sort:
            setupSortTableViewController()
        default:
            break
        }
    }

    func setupSortTableViewController() {

        tableView.isScrollEnabled = false

        for (index, sortCriteria) in organiseType.arrayValues.enumerated() {

            if selectedSortCriteria == sortCriteria {
                selectCell(indexPath: IndexPath(item: index, section: 0))
            }
        }
    }

    func selectCell(indexPath:IndexPath) {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch organiseType {
        case .sort:
            return sortCriteria.count
        case .filter:
            return filterCriteria.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SortTableViewCell else {
            return UITableViewCell()
        }

        switch organiseType {
        case .sort:
            let sortCriteria = organiseType.arrayValues[indexPath.row]

            cell.configure(string: organiseType.arrayValues[indexPath.row].stringValue)
            cell.isSelected = sortCriteria == selectedSortCriteria

        default:
            cell.configure(string: filterCriteria[indexPath.row])

        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch organiseType {
        case .sort:
            self.delegate?.sortSelected(sort: organiseType.arrayValues[indexPath.row])
            dismiss(animated: true, completion: nil)
        case .filter:
            break
        default:
            break
        }

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
