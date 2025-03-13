//
//  WeeklyPlanner+CoreDataProperties.swift
//  Plan_With_Me
//
//  Created by Tech on 2025-03-13.
//
//

import Foundation
import CoreData


extension WeeklyPlanner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeeklyPlanner> {
        return NSFetchRequest<WeeklyPlanner>(entityName: "WeeklyPlanner")
    }

    @NSManaged public var title: String?
    @NSManaged public var backgroundColor: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?

}

extension WeeklyPlanner : Identifiable {

}
