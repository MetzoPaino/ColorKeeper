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

class SortTableViewController: UITableViewController {

    //MARK: - Variables
    let sortCriteria = [Sort.alphabetical, .category, .favorite]

    weak var delegate: SortTableViewControllerDelegate?

    lazy var selectedSortCriteria: Sort = {
        Sort.alphabetical
    }()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false;
        tableView.tableFooterView = UIView()
        setupSortTableViewController()
    }

    //MARK: - Setup
    func setupSortTableViewController() {

        tableView.isScrollEnabled = false

        for (index, sortCriteria) in sortCriteria.enumerated() {

            if selectedSortCriteria == sortCriteria {
                setupSelectedCell(indexPath: IndexPath(item: index, section: 0))
            }
        }
    }

    func setupSelectedCell(indexPath:IndexPath) {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }

    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortCriteria.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SortTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(string: sortCriteria[indexPath.row].stringValue)
        cell.isSelected = sortCriteria[indexPath.row] == selectedSortCriteria

        return cell
    }

    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.delegate?.sortSelected(sort: sortCriteria[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
