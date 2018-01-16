//
//  FlagCollectionViewCell.swift
//  ColorKeeper
//
//  Created by William Robinson on 15/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class FlagCollectionViewCell: UICollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!

    //MARK: - Setup
    func configure(flag:Flag) {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let flagName = flag.name else {
            nameLabel.text = ""
            flagImageView = UIImageView()
            return
        }
        nameLabel.text = flagName
        flagImageView.image = UIImage(named: flagName)

        flagImageView.layer.shadowColor = UIColor.black.cgColor
        flagImageView.layer.shadowOpacity = 0.5
        flagImageView.layer.shadowOffset = CGSize.zero
        flagImageView.layer.shadowRadius = 1
    }
}
