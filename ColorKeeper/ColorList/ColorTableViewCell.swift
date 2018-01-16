//
//  ColorTableViewCell.swift
//  ColorKeeper
//
//  Created by William Robinson on 12/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var hexImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!

    //MARK: - View Life Cycle
    func configure(color:Color) {

        nameLabel.text = color.name
        hexLabel.text = color.hex
        if let hex = color.hex {
            hexImageView.backgroundColor = UIColor(hex: hex)
        }

        if color.favorite {
            favoriteImageView.image = #imageLiteral(resourceName: "StarSelected")
        } else {
            favoriteImageView.image = #imageLiteral(resourceName: "StarDefault")
        }
    }
}
