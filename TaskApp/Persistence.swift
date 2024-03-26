//
//  Persistence.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    private let container: NSPersistentContainer
    let viewContext: NSManagedObjectContext

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TaskApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        viewContext = container.viewContext
    }
}
