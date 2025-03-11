//
//  DailyPlanner+CoreDataProperties.swift
//  Plan_With_Me
//
//  Created by Tech on 2025-03-11.
//
//

import Foundation
import CoreData


extension DailyPlanner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyPlanner> {
        return NSFetchRequest<DailyPlanner>(entityName: "DailyPlanner")
    }

    @NSManaged public var backgroundColor: String?
    @NSManaged public var note: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?

}

extension DailyPlanner : Identifiable {

}
