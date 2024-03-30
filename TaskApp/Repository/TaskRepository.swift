//
//  TaskRepository.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 25/03/24.
//

import Foundation
import CoreData

protocol TaskRepository {
    func get(isCompleted: Bool) -> Result<[Task], TaskRepositoryError>
    func add(task: Task) -> Result<Bool, TaskRepositoryError>
    func update(task: Task) -> Result<Bool, TaskRepositoryError>
    func delete(task: Task) -> Result<Bool, TaskRepositoryError>
}

final class TaskRepositoryImplementation: TaskRepository {
    
    private let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    func get(isCompleted: Bool) -> Result<[Task], TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: isCompleted))
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if !result.isEmpty {
                return .success(result.map { taskEntity in
                    Task(id: taskEntity.id ?? UUID(), name: taskEntity.name ?? "", description: taskEntity.taskDescription ?? "", isCompleted: taskEntity.isCompleted , finishDate: taskEntity.finishDate ?? Date())
                })
            }
            return .success([])
        } catch {
            debugPrint("error in coredata \(error.localizedDescription)")
            return .failure(TaskRepositoryError.operationFailure("Unable to fetch records. Please try again later or contact support"))
        }
    }
    
    func add(task: Task) -> Result<Bool, TaskRepositoryError> {
        
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.id = UUID()
        taskEntity.isCompleted = task.isCompleted
        taskEntity.name = task.name
        taskEntity.taskDescription = task.description
        taskEntity.finishDate = task.finishDate
        
        do {
            try managedObjectContext.save()
            return .success(true)
        } catch {
            managedObjectContext.rollback()
            debugPrint("Exception \(error.localizedDescription)")
            return .failure(TaskRepositoryError.operationFailure("Unable to add task"))
        }
    }
    
    func update(task: Task) -> Result<Bool, TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                existingTask.name = task.name
                existingTask.taskDescription = task.description
                existingTask.finishDate = task.finishDate
                existingTask.isCompleted = task.isCompleted
                
                try managedObjectContext.save()
                return .success(true)
            } else {
                return   .failure(TaskRepositoryError.operationFailure("Unable to update record as id was not found."))
            }
              
        } catch {
            managedObjectContext.rollback()
            debugPrint("Exception \(error.localizedDescription)")
            return .failure(TaskRepositoryError.operationFailure("Unable to update record as id was not found."))
        }
    }
    
    func delete(task: Task) -> Result<Bool, TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                managedObjectContext.delete(existingTask)
               
                try managedObjectContext.save()
                return .success(true)
            } else {
                return .failure(TaskRepositoryError.operationFailure("Unable to delete record as id was not found."))
            }
        } catch {
            managedObjectContext.rollback()
            debugPrint("Exception \(error.localizedDescription)")
            return .failure(TaskRepositoryError.operationFailure("Unable to delete task."))
        }
    }
}
