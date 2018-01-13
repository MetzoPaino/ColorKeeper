//
//  Color.swift
//  ColorKeeper
//
//  Created by William Robinson on 12/01/2018.
//  Copyright © 2018 William Robinson. All rights reserved.
//

import Foundation
import CoreData

public class Color: NSManagedObject {

    class func fetchRequest() -> NSFetchRequest<Color> {
        return NSFetchRequest<Color>(entityName: "Color")
    }

    @NSManaged public var hex: String?
    @NSManaged public var category: String?
    @NSManaged public var name: String?
    @NSManaged public var favorite: Bool
}

