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
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func getTasks(isCompleted: Bool) {
        self.tasks = taskRepository.get(isCompleted: !isCompleted)
    }
    
    func addTask(task: Task) -> Bool {
        return taskRepository.add(task: task)
    }
    
    func updateTask(task: Task) -> Bool {
        return taskRepository.update(task: task)
    }
    
    func deleteTask(task: Task) -> Bool {
        return taskRepository.delete(task: task)
    }
}
