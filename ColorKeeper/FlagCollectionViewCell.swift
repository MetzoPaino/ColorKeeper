//
//  FlagCollectionViewCell.swift
//  ColorKeeper
//
//  Created by William Robinson on 15/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class FlagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    func configure(flag:Flag) {

        nameLabel.text = flag.name
    }
}
