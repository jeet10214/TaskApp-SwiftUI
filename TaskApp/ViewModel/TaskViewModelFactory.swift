//
//  TaskViewModelFactory.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 26/03/24.
//

import Foundation

final class TaskViewModelFactory {
    static func createTaskViewModel() -> TaskViewModel {
        return TaskViewModel(taskRepository: TaskRepositoryImplementation())
    }
}
