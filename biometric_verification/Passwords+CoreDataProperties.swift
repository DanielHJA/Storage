//
//  Passwords+CoreDataProperties.swift
//  
//
//  Created by Daniel Hjärtström on 2016-10-23.
//
//

import Foundation
import CoreData


extension Passwords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Passwords> {
        return NSFetchRequest<Passwords>(entityName: "Passwords");
    }

    @NSManaged public var icon: NSData?
    @NSManaged public var identifier: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?

}
