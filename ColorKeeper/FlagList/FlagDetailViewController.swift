//
//  FlagDetailViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 15/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class FlagDetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Variables
    var flag: Flag!

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //MARK: - Setup
    func setupView() {
        guard let flagName = flag.name else {
            title = ""
            flagImageView = UIImageView()
            return
        }
        title = flagName
        flagImageView.image = UIImage(named: flagName)
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension FlagDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let colors = flag.colors else {
            return 0
        }
        return colors.array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ColorTableViewCell else {
            return UITableViewCell()
        }

        guard let colors = flag.colors,
            let color = colors.array[indexPath.row] as? Color else {
                return cell
        }

        cell.configure(color:color)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Colors"
    }
}

//MARK: - UITableViewDelegate
extension FlagDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let colors = flag.colors,
            let color = colors.array[indexPath.row] as? Color else {
                return
        }

        color.favorite = !color.favorite
        do {
            try color.managedObjectContext?.save()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }

        tableView.reloadData()
    }
}
