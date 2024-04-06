//
//  TaskRepository.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 25/03/24.
//

import Foundation
import CoreData
import Combine

protocol TaskRepository {
    func get(isCompleted: Bool) -> AnyPublisher<Result<[Task], TaskRepositoryError>, Never>
    func add(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
    func update(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
    func delete(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
}

final class TaskRepositoryImplementation: TaskRepository {
    
    private let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    func get(isCompleted: Bool) -> AnyPublisher<Result<[Task], TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: isCompleted))
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if !result.isEmpty {
                let clientContract = result.map { taskEntity in
                    Task(id: taskEntity.id ?? UUID(), name: taskEntity.name ?? "", description: taskEntity.taskDescription ?? "", isCompleted: taskEntity.isCompleted , finishDate: taskEntity.finishDate ?? Date())
                }
                return Just(.success(clientContract)).eraseToAnyPublisher()
            }
            return Just(.success([])).eraseToAnyPublisher()
        } catch {
            debugPrint("error in coredata \(error.localizedDescription)")
            return Just(.failure(TaskRepositoryError.operationFailure("Unable to fetch records. Please try again later or contact support"))).eraseToAnyPublisher()
        }
    }
    
    func add(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.id = UUID()
        taskEntity.isCompleted = task.isCompleted
        taskEntity.name = task.name
        taskEntity.taskDescription = task.description
        taskEntity.finishDate = task.finishDate
        
        do {
            try managedObjectContext.save()
            return Just(.success(true)).eraseToAnyPublisher()
        } catch {
            managedObjectContext.rollback()
            debugPrint("Exception \(error.localizedDescription)")
            return Just(.failure(TaskRepositoryError.operationFailure("Unable to add task"))).eraseToAnyPublisher()
        }
    }
    
    func update(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                existingTask.name = task.name
                existingTask.taskDescription = task.description
                existingTask.finishDate = task.finishDate
                existingTask.isCompleted = task.isCompleted
                
                try managedObjectContext.save()
                return Just(.success(true)).eraseToAnyPublisher()
            } else {
                return Just(.failure(TaskRepositoryError.operationFailure("Unable to update record as id was not found."))).eraseToAnyPublisher()
            }
              
        } catch {
            managedObjectContext.rollback()
            debugPrint("Exception \(error.localizedDescription)")
            return Just(.failure(TaskRepositoryError.operationFailure("Unable to update record as id was not found."))).eraseToAnyPublisher()
        }
    }
    
    func delete(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                managedObjectContext.delete(existingTask)
               
                try managedObjectContext.save()
                return Just(.success(true)).eraseToAnyPublisher()
            } else {
                return Just(.failure(TaskRepositoryError.operationFailure("Unable to delete record as id was not found."))).eraseToAnyPublisher()
            }
        } catch {
            managedObjectContext.rollback()
            debugPrint("Exception \(error.localizedDescription)")
            return Just(.failure(TaskRepositoryError.operationFailure("Unable to delete task."))).eraseToAnyPublisher()
        }
    }
}
