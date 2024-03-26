//
//  TaskRepository.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 25/03/24.
//

import Foundation
import CoreData

protocol TaskRepository {
    func get(isCompleted: Bool) -> [Task]
    func add(task: Task) -> Bool
    func update(task: Task) -> Bool
    func delete(task: Task) -> Bool
}

final class TaskRepositoryImplementation: TaskRepository {
    
    private let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    func get(isCompleted: Bool) -> [Task] {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: isCompleted))
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if !result.isEmpty {
                return result.map { taskEntity in
                    Task(id: taskEntity.id ?? UUID(), name: taskEntity.name ?? "", description: taskEntity.taskDescription ?? "", isCompleted: taskEntity.isCompleted , finishDate: taskEntity.finishDate ?? Date())
                }
            }
        } catch {
            debugPrint("error in coredata \(error.localizedDescription)")
        }
        
        return []
    }
    
    func add(task: Task) -> Bool {
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.id = UUID()
        taskEntity.isCompleted = task.isCompleted
        taskEntity.name = task.name
        taskEntity.taskDescription = task.description
        taskEntity.finishDate = task.finishDate
        
        do {
            try managedObjectContext.save()
            return true
        } catch {
            debugPrint("Exception \(error.localizedDescription)")
        }
        
        return false
    }
    
    func update(task: Task) -> Bool {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                existingTask.name = task.name
                existingTask.taskDescription = task.description
                existingTask.finishDate = task.finishDate
                existingTask.isCompleted = task.isCompleted
                
                try managedObjectContext.save()
                return true
            }
        } catch {
            debugPrint("Exception \(error.localizedDescription)")
        }
        
        return false
    }
    
    func delete(task: Task) -> Bool {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                managedObjectContext.delete(existingTask)
               
                try managedObjectContext.save()
                return true
            }
        } catch {
            debugPrint("Exception \(error.localizedDescription)")
        }
        
        return false
    }
    
}
