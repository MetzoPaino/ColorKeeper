//
//  ColorTableViewCell.swift
//  ColorKeeper
//
//  Created by William Robinson on 12/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var hexImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!

    // MARK: - View Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = nil
        hexLabel.text = nil
        hexImageView.image = nil
        favoriteImageView.image = nil
    }

    func configure(color:Color) {

        nameLabel.text = color.name
        hexLabel.text = color.hex
        hexImageView.backgroundColor = UIColor(hex: color.hex!)
        
        if color.favorite {
            favoriteImageView.image = #imageLiteral(resourceName: "StarSelected")
        } else {
            favoriteImageView.image = #imageLiteral(resourceName: "StarDefault")
        }
    }
}
