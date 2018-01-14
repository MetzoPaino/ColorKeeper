//
//  FilterTableViewCell.swift
//  ColorKeeper
//
//  Created by William Robinson on 13/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!

    // MARK: - View Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }

    func configure(string: String) {
        label.text = string

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.green
        selectedBackgroundView = backgroundView
    }
}
