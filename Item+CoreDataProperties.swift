//
//  Item+CoreDataProperties.swift
//  SMR App
//
//  Created by Tanner George on 5/13/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var period1: String?

}

extension Item : Identifiable {

}
