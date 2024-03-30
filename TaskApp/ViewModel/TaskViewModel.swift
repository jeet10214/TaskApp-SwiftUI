//
//  TaskViewModel.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import Foundation

final class TaskViewModel: ObservableObject {
    
    private var taskRepository: TaskRepository
    
    @Published var tasks: [Task] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func getTasks(isCompleted: Bool) {
        let result = taskRepository.get(isCompleted: !isCompleted)
        switch result {
        case .success(let fetchedTask):
            errorMessage = ""
            self.tasks = fetchedTask
        case .failure(let failure):
            errorMessage = processError(failure)
        }
    }
    
    func addTask(task: Task) -> Bool {
        let result = taskRepository.add(task: task)
        switch result {
        case .success(let addTaskStatus):
            errorMessage = ""
            return addTaskStatus
        case .failure(let failure):
            errorMessage = processError(failure)
            return false
        }
    }
    
    func updateTask(task: Task) -> Bool {
        let result = taskRepository.update(task: task)
        switch result {
        case .success(let updateTaskStatus):
            errorMessage = ""
            return updateTaskStatus
        case .failure(let failure):
            errorMessage = processError(failure)
            return false
        }
    }
    
    func deleteTask(task: Task) -> Bool {
        let result =  taskRepository.delete(task: task)
        switch result {
        case .success(let deleteTaskStatus):
            errorMessage = ""
            return deleteTaskStatus
        case .failure(let failure):
            errorMessage = processError(failure)
            return false
        }
    }
    
    private func processError(_ error: TaskRepositoryError) -> String {
        switch error {
        case .operationFailure(let errorMessage):
            showError = true
            return errorMessage
        }
    }
}
