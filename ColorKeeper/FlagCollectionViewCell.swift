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
    @IBOutlet weak var flagColorImageView1: UIImageView!
    @IBOutlet weak var flagColorImageView2: UIImageView!
    @IBOutlet weak var flagColorImageView3: UIImageView!

    func configure(flag:Flag) {

        nameLabel.text = flag.name
//        let test = flag.colors!.array[0] as! Color
//
//        let color1 = UIColor(hex: test.hex!)
////        let color2 = UIColor(hex:flag.colors!.array[1].hex! as! Color)
////        let color3 = UIColor(hex:flag.colors!.array[2].hex! as! Color)
//
//        flagColorImageView1.backgroundColor = color1
//        flagColorImageView2.backgroundColor = color1
//        flagColorImageView3.backgroundColor = color1
    }
}
