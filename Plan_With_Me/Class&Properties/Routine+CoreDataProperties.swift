//
//  Routine+CoreDataProperties.swift
//  Plan_With_Me
//
//  Created by Tech on 2025-03-13.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var title: String?
    @NSManaged public var backgroundColor: String?
    @NSManaged public var frequency: String?

}

extension Routine : Identifiable {

}
