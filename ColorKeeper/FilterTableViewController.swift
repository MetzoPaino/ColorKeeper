//
//  FilterTableViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 13/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

protocol SortTableViewControllerDelegate: class {
    func sortSelected(sort: Sort)
}

class FilterTableViewController: UITableViewController {

    weak var delegate: SortTableViewControllerDelegate?

    let sortArray = [Sort.alphabetical, .category, .favorite]
    lazy var selectedFilter = sortArray.first

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false;
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        selectCell(indexPath: IndexPath(item: 0, section: 0))
    }

    func selectCell(indexPath:IndexPath) {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FilterTableViewCell else {
            return UITableViewCell()
        }

        let sortCriterea = sortArray[indexPath.row]
        cell.configure(string: sortArray[indexPath.row].stringValue)
        cell.isSelected = sortCriterea == selectedFilter

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.sortSelected(sort: sortArray[indexPath.row])
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
