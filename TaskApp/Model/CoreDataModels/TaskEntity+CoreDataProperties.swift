//
//  TaskEntity+CoreDataProperties.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 25/03/24.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var taskDescription: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var finishDate: Date?

}

extension TaskEntity : Identifiable {

}
