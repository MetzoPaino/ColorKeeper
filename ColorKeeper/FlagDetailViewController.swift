//
//  FlagDetailViewController.swift
//  ColorKeeper
//
//  Created by William Robinson on 15/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class FlagDetailViewController: UIViewController {

    var flag: Flag!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(flag.getColorsArray())
        title = flag.name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}

// MARK: - UITableViewDataSource
extension FlagDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let sectionInfo = fetchedResultsController.sections?[section] else {
//            return 0
//        }
        return flag.getColorsArray().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ColorTableViewCell else {
            return UITableViewCell()
        }

//        if let color = flag.getColorsArray()[indexPath.row] {
//            cell.configure(color:color)
//        }

        let color = flag.getColorsArray()[indexPath.row]
        cell.configure(color:color)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}

// MARK: - UITableViewDelegate
extension FlagDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let color = fetchedResultsController.object(at: indexPath)
//        color.favorite = !color.favorite
//        coreDataStack.saveContext()
    }
}
